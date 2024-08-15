require 'nokogiri'

class ReportsController < ApplicationController
  attr_accessor :report

  before_action :authenticate_user!
  before_action :set_report!, only: [:show, :export_to_excel]

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      ProcessXmlJob.perform_async(@report.id)

      redirect_to @report, notice: 'Relatório enviado para processamento em segundo plano.'
    else
      render :new
    end
  end

  def show
    if report.products.blank?
      flash[:notice] = 'O relatório ainda está sendo processado. Você será redirecionado em breve...'
      render :processing
    end
  end

  def export_to_excel
    file_path = Reports::ExportToExcel.new(report).execute

    send_file file_path, filename: "relatorio_#{report.id}.xlsx", type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end

  def import_zip
    response = Reports::ImportZip.new(params[:zip_file]).execute
    
    if response
      redirect_to reports_path, notice: 'Arquivos XML importados e processados com sucesso.'
    else
      redirect_to new_report_path, alert: 'Ocorreu um erro ao processar o arquivo ZIP.'
    end
  end

  private

  def report_params
    params.require(:report).permit(:xml_file)
  end

  def set_report!
    @report = Report.find(params[:id])
  end  
end
