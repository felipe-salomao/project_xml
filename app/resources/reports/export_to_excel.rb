class Reports::ExportToExcel
  attr_accessor :report

  def initialize(report)
    @report = report
  end

  def execute
    mount_to_xlsx
  end

  private

  def mount_to_xlsx
    tmp_dir = Rails.root.join('tmp')
    file_path = File.join(tmp_dir, "relatorio_#{report.id}.xlsx")

    workbook = WriteXLSX.new(file_path)
    worksheet = workbook.add_worksheet

    mount_document_info(worksheet)
    mount_emitter(worksheet)
    mount_receiver(worksheet)
    mount_products(worksheet)
    mount_totalizers(worksheet)

    workbook.close
    file_path
  end

  def mount_document_info(worksheet)
    worksheet.write(0, 0, "Dados do Documento Fiscal")
    worksheet.write(1, 0, "Série")
    worksheet.write(1, 1, report.document_info.serie)
    worksheet.write(2, 0, "Número da Nota Fiscal")
    worksheet.write(2, 1, report.document_info.nnf)
    worksheet.write(3, 0, "Data e Hora de Emissão")
    worksheet.write(3, 1, report.document_info.dhemi)
  end

  def mount_emitter(worksheet)
    worksheet.write(5, 0, "Emitente")
    worksheet.write(6, 0, "Documento")
    worksheet.write(6, 1, report.document_info.companies.emitter.first.document)
    worksheet.write(7, 0, "Nome")
    worksheet.write(7, 1, report.document_info.companies.emitter.first.name)
  end

  def mount_receiver(worksheet)
    worksheet.write(9, 0, "Destinatário")
    worksheet.write(10, 0, "Documento")
    worksheet.write(10, 1, report.document_info.companies.receiver.first.document)
    worksheet.write(11, 0, "Nome")
    worksheet.write(11, 1, report.document_info.companies.receiver.first.name)
  end

  def mount_products(worksheet)
    worksheet.write(13, 0, "Produtos Listados")
    worksheet.write(14, 0, "Nome")
    worksheet.write(14, 1, "NCM")
    worksheet.write(14, 2, "CFOP")
    worksheet.write(14, 3, "Unidade")
    worksheet.write(14, 4, "Quantidade")
    worksheet.write(14, 5, "Valor Unitário")

    report.products.each_with_index do |produto, index|
      row = index + 15
      worksheet.write(row, 0, produto.name)
      worksheet.write(row, 1, produto.ncm)
      worksheet.write(row, 2, produto.cfop)
      worksheet.write(row, 3, produto.unity)
      worksheet.write(row, 4, produto.quantity)
      worksheet.write(row, 5, produto.value)
    end
  end

  def mount_taxes(worksheet)
    worksheet.write(16 + report.products.count, 0, "Impostos Associados")
    worksheet.write(17 + report.products.count, 0, "ICMS")
    worksheet.write(17 + report.products.count, 1, report.tax.icms)
    worksheet.write(18 + report.products.count, 0, "IPI")
    worksheet.write(18 + report.products.count, 1, report.tax.ipi)
  end

  def mount_totalizers(worksheet)
    worksheet.write(20 + report.products.count, 0, "Totalizadores")
    worksheet.write(21 + report.products.count, 0, "Total dos Produtos")
    worksheet.write(21 + report.products.count, 1, report.totalizer.total_products)
    worksheet.write(22 + report.products.count, 0, "Total dos Impostos")
    worksheet.write(22 + report.products.count, 1, report.totalizer.total_taxes)
  end
end
