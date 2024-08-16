module CompanyHelperMethods
  def format_cnpj
    cnpj = document.to_s.gsub(/\D/, '')

    return 'CNPJ inválido' unless cnpj.length == 14

    cnpj.gsub(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '\1.\2.\3/\4-\5')
  end
end