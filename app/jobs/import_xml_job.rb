class ImportXmlJob
  include Sidekiq::Worker

  def perform(report_id)
    report = Report.find(report_id)
    import_xml(report)
  end

  private

  def import_xml(report)
    file_path = report.xml_file.path
    doc = Nokogiri::XML(File.open(file_path))
    nfe_namespace = { 'nfe' => 'http://www.portalfiscal.inf.br/nfe' }

    # Informações do documento
    document_info = DocumentInfo.create!(
      serie: doc.xpath('//nfe:serie', nfe_namespace).text,
      nnf: doc.xpath('//nfe:nNF', nfe_namespace).text,
      dhemi: doc.xpath('//nfe:dhEmi', nfe_namespace).text,
      report_id: report.id
    )

    # Informações do emitente e destinatario
    mount_company(doc, 'emit', :emitter, document_info.id, nfe_namespace)
    mount_company(doc, 'dest', :receiver, document_info.id, nfe_namespace)

    # Informações dos produtos
    mount_product(doc, nfe_namespace, report.id)

    # Informações dos impostos
    mount_tax(doc, nfe_namespace, report.id)

    # Calcular totalizadores
    mount_totalizer(report.id)

    report.save
  end

  def mount_company(doc, role, entity_type, document_info_id, nfe_namespace)
    company_xml = doc.xpath("//nfe:#{role}", nfe_namespace)

    company = Company.create!(
      document: company_xml.xpath('nfe:CNPJ', nfe_namespace).text,
      name: company_xml.xpath('nfe:xNome', nfe_namespace).text,
      fantasy: company_xml.xpath('nfe:xFant', nfe_namespace).text,
      ie: company_xml.xpath('nfe:IE', nfe_namespace).text.presence&.to_i,
      ind_ie: company_xml.xpath('nfe:indIEDest', nfe_namespace).text.presence&.to_i,
      crt: company_xml.xpath('nfe:CRT', nfe_namespace).text.presence&.to_i,
      entity_type: entity_type,
      document_info_id: document_info_id
    )

    mount_address(company_xml, role.capitalize, nfe_namespace, company.id)
  end

  def mount_address(company_xml, role, nfe_namespace, company_id)
    Address.create!(
      lgr: company_xml.xpath("nfe:ender#{role}/nfe:xLgr", nfe_namespace).text,
      nro: company_xml.xpath("nfe:ender#{role}/nfe:nro", nfe_namespace).text.to_i,
      cpl: company_xml.xpath("nfe:ender#{role}/nfe:xCpl", nfe_namespace).text,
      neighborhood: company_xml.xpath("nfe:ender#{role}/nfe:xBairro", nfe_namespace).text,
      mun: company_xml.xpath("nfe:ender#{role}/nfe:cMun", nfe_namespace).text.to_i,
      uf: company_xml.xpath("nfe:ender#{role}/nfe:UF", nfe_namespace).text,
      cep: company_xml.xpath("nfe:ender#{role}/nfe:CEP", nfe_namespace).text,
      cod_country: company_xml.xpath("nfe:ender#{role}/nfe:cPais", nfe_namespace).text.to_i,
      country: company_xml.xpath("nfe:ender#{role}/nfe:xPais", nfe_namespace).text,
      phone: company_xml.xpath("nfe:ender#{role}/nfe:fone", nfe_namespace).presence&.text,
      company_id: company_id
    )
  end

  def mount_product(doc, nfe_namespace, report_id)
    doc.xpath('//nfe:det/nfe:prod', nfe_namespace).each do |prod|
      Product.create!(
        name: prod.xpath('nfe:xProd', nfe_namespace).text,
        ncm: prod.xpath('nfe:NCM', nfe_namespace).text.to_i,
        cfop: prod.xpath('nfe:CFOP', nfe_namespace).text.to_i,
        unity: prod.xpath('nfe:uCom', nfe_namespace).text,
        quantity: prod.xpath('nfe:qCom', nfe_namespace).text.to_f,
        value: prod.xpath('nfe:vUnCom', nfe_namespace).text.to_f,
        report_id: report_id
      )
    end
  end

  def mount_tax(doc, nfe_namespace, report_id)
    Tax.create!(
      icms: doc.xpath('//nfe:ICMS//nfe:vICMS', nfe_namespace).text.to_f,
      ipi: doc.xpath('//nfe:IPI//nfe:vIPI', nfe_namespace).text.to_f,
      pis: doc.xpath('//nfe:PIS//nfe:vPIS', nfe_namespace).text.to_f,
      cofins: doc.xpath('//nfe:COFINS//nfe:vCOFINS', nfe_namespace).text.to_f,
      report_id: report_id
    )
  end

  def mount_totalizer(report_id)
    total_products = Product.where(report_id: report_id).sum('quantity * value')
    total_taxes = Tax.where(report_id: report_id).sum('icms + ipi + pis + cofins')

    Totalizer.create!(
      total_products: total_products,
      total_taxes: total_taxes,
      report_id: report_id
    )
  end
end
