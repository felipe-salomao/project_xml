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

  def export_to_excel
    @report = Report.find(params[:id])

    tmp_dir = Rails.root.join('tmp')
    file_path = File.join(tmp_dir, "relatorio_#{@report.id}.xlsx")

    workbook = WriteXLSX.new(file_path)
    worksheet = workbook.add_worksheet

    worksheet.write(0, 0, "Dados do Documento Fiscal")
    worksheet.write(1, 0, "Série")
    worksheet.write(1, 1, @report.document_info.serie)
    worksheet.write(2, 0, "Número da Nota Fiscal")
    worksheet.write(2, 1, @report.document_info.nnf)
    worksheet.write(3, 0, "Data e Hora de Emissão")
    worksheet.write(3, 1, @report.document_info.dhemi)

    worksheet.write(5, 0, "Emitente")
    worksheet.write(6, 0, "Documento")
    worksheet.write(6, 1, @report.document_info.companies.emitter.first.document)
    worksheet.write(7, 0, "Nome")
    worksheet.write(7, 1, @report.document_info.companies.emitter.first.name)

    worksheet.write(9, 0, "Destinatário")
    worksheet.write(10, 0, "Documento")
    worksheet.write(10, 1, @report.document_info.companies.receiver.first.document)
    worksheet.write(11, 0, "Nome")
    worksheet.write(11, 1, @report.document_info.companies.receiver.first.name)

    worksheet.write(13, 0, "Produtos Listados")
    worksheet.write(14, 0, "Nome")
    worksheet.write(14, 1, "NCM")
    worksheet.write(14, 2, "CFOP")
    worksheet.write(14, 3, "Unidade")
    worksheet.write(14, 4, "Quantidade")
    worksheet.write(14, 5, "Valor Unitário")
    
    @report.products.each_with_index do |produto, index|
      row = index + 15
      worksheet.write(row, 0, produto.name)
      worksheet.write(row, 1, produto.ncm)
      worksheet.write(row, 2, produto.cfop)
      worksheet.write(row, 3, produto.unity)
      worksheet.write(row, 4, produto.quantity)
      worksheet.write(row, 5, produto.value)
    end

    worksheet.write(16 + @report.products.count, 0, "Impostos Associados")
    worksheet.write(17 + @report.products.count, 0, "ICMS")
    worksheet.write(17 + @report.products.count, 1, @report.tax.icms)
    worksheet.write(18 + @report.products.count, 0, "IPI")
    worksheet.write(18 + @report.products.count, 1, @report.tax.ipi)

    worksheet.write(20 + @report.products.count, 0, "Totalizadores")
    worksheet.write(21 + @report.products.count, 0, "Total dos Produtos")
    worksheet.write(21 + @report.products.count, 1, @report.totalizer.total_products)
    worksheet.write(22 + @report.products.count, 0, "Total dos Impostos")
    worksheet.write(22 + @report.products.count, 1, @report.totalizer.total_taxes)

    workbook.close

    send_file file_path, filename: "relatorio_#{@report.id}.xlsx", type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end

  def import_zip
    if params[:zip_file].present?
      zip_file = params[:zip_file]
      
      begin
        process_zip(zip_file)
        redirect_to reports_path, notice: 'Arquivos XML importados e processados com sucesso.'
      rescue StandardError => e
        Rails.logger.error "Erro ao processar o arquivo ZIP: #{e.message}"
        redirect_to reports_path, alert: 'Ocorreu um erro ao processar o arquivo ZIP.'
      end
    else
      redirect_to reports_path, alert: 'Por favor, selecione um arquivo ZIP para upload.'
    end
  end

  private

  def report_params
    params.require(:report).permit(:xml_file)
  end

  def process_zip(zip_file)
    Zip::File.open(zip_file.path) do |zip_file|
      zip_file.each do |entry|
        next unless entry.file? && entry.name.end_with?('.xml')
  
        tmp_dir = Rails.root.join('tmp')
        file_path = File.join(tmp_dir, entry.name)

        entry.extract(file_path)
  
        report = Report.create!(xml_file: File.open(file_path))
  
        ProcessXmlJob.perform_async(report.id)
      end
    end
  end  
end
