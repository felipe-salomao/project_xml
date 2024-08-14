# app/jobs/process_xml_job.rb
class ProcessXmlJob
  include Sidekiq::Worker

  def perform(report_id)
    report = Report.find(report_id)
    process_xml(report)
  end

  private

  def process_xml(report)
    file_path = report.xml_file.path
    doc = Nokogiri::XML(File.open(file_path))

    # Define o namespace padrão para o XML da NFe
    nfe_namespace = { 'nfe' => 'http://www.portalfiscal.inf.br/nfe' }

    # Extração de informações básicas
    report.serie = doc.xpath('//nfe:serie', nfe_namespace).text
    report.nNF = doc.xpath('//nfe:nNF', nfe_namespace).text
    report.dhEmi = doc.xpath('//nfe:dhEmi', nfe_namespace).text

    # Extração e formatação dos dados do emitente
    emitente = doc.xpath('//nfe:emit', nfe_namespace)
    report.emit = {
      CNPJ: emitente.xpath('nfe:CNPJ', nfe_namespace).text,
      xNome: emitente.xpath('nfe:xNome', nfe_namespace).text,
      xFant: emitente.xpath('nfe:xFant', nfe_namespace).text,
      enderEmit: {
        xLgr: emitente.xpath('nfe:enderEmit/nfe:xLgr', nfe_namespace).text,
        nro: emitente.xpath('nfe:enderEmit/nfe:nro', nfe_namespace).text,
        xBairro: emitente.xpath('nfe:enderEmit/nfe:xBairro', nfe_namespace).text,
        xMun: emitente.xpath('nfe:enderEmit/nfe:xMun', nfe_namespace).text,
        UF: emitente.xpath('nfe:enderEmit/nfe:UF', nfe_namespace).text,
        CEP: emitente.xpath('nfe:enderEmit/nfe:CEP', nfe_namespace).text
      }
    }.to_json

    # Extração e formatação dos dados do destinatário
    destinatario = doc.xpath('//nfe:dest', nfe_namespace)
    report.dest = {
      CNPJ: destinatario.xpath('nfe:CNPJ', nfe_namespace).text,
      xNome: destinatario.xpath('nfe:xNome', nfe_namespace).text,
      enderDest: {
        xLgr: destinatario.xpath('nfe:enderDest/nfe:xLgr', nfe_namespace).text,
        nro: destinatario.xpath('nfe:enderDest/nfe:nro', nfe_namespace).text,
        xBairro: destinatario.xpath('nfe:enderDest/nfe:xBairro', nfe_namespace).text,
        xMun: destinatario.xpath('nfe:enderDest/nfe:xMun', nfe_namespace).text,
        UF: destinatario.xpath('nfe:enderDest/nfe:UF', nfe_namespace).text,
        CEP: destinatario.xpath('nfe:enderDest/nfe:CEP', nfe_namespace).text
      }
    }.to_json

    # Processar produtos
    produtos = []
    doc.xpath('//nfe:det/nfe:prod', nfe_namespace).each do |prod|
      produtos << {
        nome: prod.xpath('nfe:xProd', nfe_namespace).text,
        ncm: prod.xpath('nfe:NCM', nfe_namespace).text,
        cfop: prod.xpath('nfe:CFOP', nfe_namespace).text,
        ucom: prod.xpath('nfe:uCom', nfe_namespace).text,
        qcom: prod.xpath('nfe:qCom', nfe_namespace).text,
        vuncom: prod.xpath('nfe:vUnCom', nfe_namespace).text
      }
    end
    report.produtos = produtos.to_json

    # Processar impostos
    impostos = {
      icms: doc.xpath('//nfe:ICMS//nfe:vICMS', nfe_namespace).map(&:text).map(&:to_f).sum,
      ipi: doc.xpath('//nfe:IPI//nfe:vIPI', nfe_namespace).map(&:text).map(&:to_f).sum,
      pis: doc.xpath('//nfe:PIS//nfe:vPIS', nfe_namespace).map(&:text).map(&:to_f).sum,
      cofins: doc.xpath('//nfe:COFINS//nfe:vCOFINS', nfe_namespace).map(&:text).map(&:to_f).sum
    }
    report.impostos = impostos.to_json

    # Calcular totalizadores
    total_produtos = produtos.sum { |p| p[:qcom].to_f * p[:vuncom].to_f }
    total_impostos = impostos.values.sum
    report.totalizadores = {
      total_produtos: total_produtos,
      total_impostos: total_impostos
    }.to_json

    report.save
  end
end
