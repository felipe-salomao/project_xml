class ReportsController < ApplicationController
  attr_accessor :report

  before_action :authenticate_user!
  before_action :set_report!, only: [:show, :export_to_excel]

  def index
    @reports = current_user.reports.order(created_at: :desc)
  end

  def new
    @report = current_user.reports.new
  end

  def create
    return render :new if params[:report].blank?

    @report = current_user.reports.create!(report_params)
    ImportXmlJob.perform_async(@report.id)

    redirect_to @report, notice: 'Arquivo XML importado com sucesso.'
  end

  def show
    if report.document_info.blank?
      flash[:notice] = 'O relatório ainda está sendo processado. Você será redirecionado em breve...'
      render :processing
    end
  end

  def export_to_excel
    file_path = Reports::ExportToExcel.new(report).execute

    send_file file_path, filename: "relatorio_#{report.id}.xlsx", type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end

  def import_zip
    response = Reports::ImportZip.new(current_user, params[:zip_file]).execute
    
    if response
      redirect_to root_path, notice: 'Arquivo ZIP importado com sucesso.'
    else
      redirect_to new_report_path, alert: 'Ocorreu um erro ao importar o arquivo ZIP.'
    end
  end

  private

  def report_params
    params.require(:report).permit(:xml_file)
  end

  def set_report!
    @report = current_user.reports.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Relatório não encontrado.'
  end
end
