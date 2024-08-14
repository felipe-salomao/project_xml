source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Usado como servidor de aplicativos
gem 'puma', '~> 5.0'

# Utiliza SCSS para stylesheets
gem 'sass-rails', '>= 6'

# Usado para permitir o uso de módulos JavaScript
gem 'webpacker', '~> 5.0'

# Usado para tornar a navegação da web mais rápida
gem 'turbolinks', '~> 5'

# Usado para criar APIs JSON com facilidade
gem 'jbuilder', '~> 2.7'

# Renderiza imagem no ActionText
gem 'image_processing', '~> 1.2'

# Reduz o tempo de inicialização através do cache
gem 'bootsnap', '>= 1.4.4', require: false

# Fornece dados de fuso horário atualizados
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Usado para simplificar a criação de formulários HTML
gem "simple_form", "~> 5.3"

# Usada para facilitar a paginação
gem "kaminari", "~> 1.2"

# Usado para autenticação de usuários
gem "devise", "~> 4.9"

# Extensão da gem devise para fornecer traduções
gem 'devise-i18n', "~> 1.10.1"

# Biblioteca para gerenciar as permissões de acesso dos usuários
gem "pundit", "~> 2.3"

# Usada para gerenciar roles de usuário
gem 'rolify', '~> 6.0'

# Simplifica a manipulação e agrupamento de datas e horas
gem "groupdate", "~> 5.2"

# Usada para carregar variáveis de ambiente
gem 'dotenv-rails'

# Biblioteca para execução de tarefas assíncronas
gem 'sidekiq', '~> 6.4'
gem 'redis'

# Usada para fazer upload de arquivos
gem 'carrierwave'

group :development, :rspec, :test do
  # Usado para interromper a execução e obter um console do depurador
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Usada para escrever e executar testes
  gem 'rspec-rails', '~> 6.0'

  # Usado para criar dados de teste
  gem 'factory_bot_rails', '~> 6.2'

  # Usado para gerar dados fictícios para testes
  gem 'faker', '~> 3.3', '>= 3.3.1'

  # Facilita a escrita de testes, oferece uma coleção de matchers
  gem 'shoulda-matchers', '~> 4.5', '>= 4.5.1'

  # Fornece suporte para testes de controllers
  gem 'rails-controller-testing'
end

group :development do
  # Fornece um console interativo no navegador
  gem 'web-console', '>= 4.1.0'

  # Ajuda a identificar gargalos de desempenho na aplicação
  gem 'rack-mini-profiler', '~> 2.0'

  # Usada para visualizar e testar emails enviados durante o desenvolvimento
  gem "letter_opener", "~> 1.10"

  # Ferramenta de detecção de N+1 queries
  gem "bullet"
end

group :test do
  # Simula a interação do usuário com a aplicação web
  gem 'capybara', '>= 3.26'

  # Biblioteca para automatizar testes de interface do usuário
  gem 'selenium-webdriver', '>= 4.0.0.rc1'

  # Gerencia e instala os drivers web para executar testes de sistema com navegadores
  gem 'webdrivers'
end
