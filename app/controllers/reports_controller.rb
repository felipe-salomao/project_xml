require 'nokogiri'

class ReportsController < ApplicationController
  before_action :authenticate_user!

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
    @report = Report.find(params[:id])

    unless @report.products.present?
      flash[:notice] = 'O relatório ainda está sendo processado. Você será redirecionado em breve...'
      render :processing
    end
  end

  private

  def report_params
    params.require(:report).permit(:xml_file)
  end
end
