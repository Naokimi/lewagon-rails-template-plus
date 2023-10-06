=begin
find gem that automatically adds frozen string on top of file
modify rubocop rule to ignore toplevel documentation
=end

supported_version = ENV['SUPPORTED_RAILS_VERSION'].to_i
unless Rails.version.to_i == supported_version
  puts '-----------------'
  puts "This template supports only Rails version #{unsupported_version}"
  puts '-----------------'
  return
end

FileUtils.rm_rf('app/assets/stylesheets')
FileUtils.rm_rf('vendor')
require 'open-uri'
open('https://github.com/lewagon/rails-stylesheets/archive/master.zip') do |file|
  Zip::File.open_buffer(file.read) do |zip_file|
    zip_file.each do |entry|
      entry.extract("app/assets/stylesheets/#{entry.name}") { true }
    end
  end
end

def remove_assets
  FileUtils.rm_rf('app/assets/stylesheets')
  FileUtils.rm_rf('vendor')
end

def import_stylesheets
  require 'open-uri'
  open('https://github.com/lewagon/rails-stylesheets/archive/master.zip') do |file|
    Zip::File.open_buffer(file.read) do |zip_file|
      zip_file.each do |entry|
        entry.extract("app/assets/stylesheets/#{entry.name}") { true }
      end
    end
  end
end

remove_assets
import_stylesheets

file 'app/views/layouts/application.html.slim', <<~HTML
  doctype html
  html
    head
      title RailsTemplateApp
      meta name="viewport" content="width=device-width,initial-scale=1"
      = csrf_meta_tags
      = csp_meta_tag

      meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"
      = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
      = javascript_include_tag 'application', 'data-turbolinks-track': 'reload', defer: true

    body
      = render 'shared/navbar'
      = render 'shared/flashes'

      .container
        = yield

      = render 'shared/footer'
HTML

file 'app/views/shared/_flashes.html.slim', <<~HTML
  - if notice
    .alert.alert-info.alert-dismissible.fade.show.m-1 role="alert"
      = notice
      button.btn-close type="button" data-bs-dismiss="alert" aria-label="Close"
  - if alert
    .alert.alert-warning.alert-dismissible.fade.show.m-1 role="alert"
      = alert
      button.btn-close type="button" data-bs-dismiss="alert" aria-label="Close"
HTML

file 'app/views/shared/_navbar.html.slim', <<~HTML
  .navbar.navbar-expand-sm.navbar-light.navbar-lewagon.px-3
    .container
      = link_to "#", class: "navbar-brand" do
        = image_tag "https://raw.githubusercontent.com/lewagon/fullstack-images/master/uikit/logo.png"

      button.navbar-toggler type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"
        span.navbar-toggler-icon

      .collapse.navbar-collapse id="navbarSupportedContent"
        ul.navbar-nav.mr-auto
          - if user_signed_in?
            li.nav-item.active
              = link_to "Home", "#", class: "nav-link"
            li.nav-item
              = link_to "Messages", "#", class: "nav-link"
            li.nav-item.dropdown
              = image_tag "https://kitt.lewagon.com/placeholder/users/ssaunier", class: "avatar dropdown-toggle", id: "navbarDropdown", data: { toggle: "dropdown" }, 'aria-haspopup': true, 'aria-expanded': false
              .dropdown-menu.dropdown-menu-right aria-labelledby="navbarDropdown"
                = link_to "Action", "#", class: "dropdown-item"
                = link_to "Another action", "#", class: "dropdown-item"
                = link_to "Log out", destroy_user_session_path, method: :delete, class: "dropdown-item"
          - else
            li.nav-item
              = link_to "Login", new_user_session_path, class: "nav-link"
HTML

file 'app/views/shared/_footer.html.slim', <<~HTML
  footer.container.d-flex.flex-wrap.justify-content-between.align-items-center.py-3.my-4.border-top
    p.col-md-4.mb-0.text-muted © #{Date.today.year} Company, Inc
HTML

inject_into_file "config/initializers/assets.rb", before: "# Precompile additional assets." do
  <<~RUBY
    Rails.application.config.assets.paths << Rails.root.join("node_modules")
  RUBY
end

# Rest of the code remains the sameaction", "#", class: "dropdown-item"
                = link_to "Log out", destroy_user_session_path, method: :delete, class: "dropdown-item"
          - else
            li.nav-item
              = link_to "Login", new_user_session_path, class: "nav-link"
HTML

file 'app/views/shared/_footer.html.slim', <<~HTML
  footer.container.d-flex.flex-wrap.justify-content-between.align-items-center.py-3.my-4.border-top
    p.col-md-4.mb-0.text-muted © #{Date.today.year} Company, Inc
HTML


# README
########################################
markdown_file_content = <<~MARKDOWN
  Rails app generated with [Naokimi/lewagon-rails-templates-plus](https://github.com/Naokimi/lewagon-rails-templates-plus).
MARKDOWN
file 'README.md', markdown_file_content, force: true

# Generators
########################################
generators = <<~RUBY
  config.generators do |generate|
    generate.assets false
    generate.helper false
    generate.test_framework :rspec
    generate.fixture_replacement :factory_bot, dir: 'spec/support/factories'
  end
RUBY

environment generators

########################################
# AFTER BUNDLE
########################################
after_bundle do
  # Disable spring for recreated apps
  ########################################
  run 'export DISABLE_SPRING=true'

  # Generators: db + simple form + pundit + annotate + pages controller
  ########################################
  rails_command 'db:drop db:create db:migrate'
  generate('simple_form:install', '--bootstrap')
  generate('pundit:install')
  generate('annotate:install')
  generate(:controller, 'pages', 'home', '--skip-routes', '--no-test-framework')
  # Routes
  ########################################
  route "root to: 'pages#home'"

  # Git ignore
  ########################################
  append_file '.gitignore', <<~TXT
    # Ignore .env file containing credentials.
    .env*
    # Ignore Mac and Linux file system files
    *.swp
    .DS_Store

    /node_modules
  TXT

  # Devise install + user
  ########################################
  generate('devise:install')
  generate('devise', 'User')

  # App controller
  ########################################
  run 'rm app/controllers/application_controller.rb'
  file 'app/controllers/application_controller.rb', <<~RUBY
    class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    end
  RUBY

  # Migrate + devise views
  ########################################
  rails_command 'db:migrate'
  generate('devise:views')

  # Pages Controller
  ########################################
  run 'rm app/controllers/pages_controller.rb'
  file 'app/controllers/pages_controller.rb', <<~RUBY
    class PagesController < ApplicationController
      skip_before_action :authenticate_user!, only: [ :home ]
      def home
      end
    end
  RUBY

  # Environments
  ########################################
  environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'
  environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }', env: 'production'

  # Get rid of `test` directory
  #######################################
  run 'rm -rf test'

  # Test config
  #######################################
  generate('rspec:install')
  inject_into_file 'spec/spec_helper.rb', before: '# This file was generated' do
    <<-RUBY
      require 'simplecov'
      SimpleCov.start 'rails'
    RUBY
  end

  inject_into_file 'spec/spec_helper.rb', after: '=end' do
    <<-RUBY

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.around(:each) do |example|
      DatabaseCleaner.cleaning do
        example.run
      end
    end
    RUBY
  end

  # Rspec support files
  #######################################
  file 'spec/support/devise.rb', <<~RUBY
    require 'devise'

    RSpec.configure do |config|
      config.include Devise::Test::ControllerHelpers, type: :controller
    end
  RUBY

  file 'spec/support/factory_bot.rb', <<~RUBY
    require 'factory_bot'

    RSpec.configure do |config|
      config.include FactoryBot::Syntax::Methods
    end
  RUBY

  inject_into_file 'spec/rails_helper.rb', after: "require 'rspec/rails'" do
    <<~RUBY

      Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
    RUBY
  end

  # Factories
  #######################################
  inject_into_file 'spec/support/factories/users.rb', after: 'factory :user do' do
    <<~RUBY

      email    { 'gmail@chucknorris.com' }
      password { 'roundhousekick' }
    RUBY
  end

  # Seeds config
  ######################################
  remove_file 'db/seeds.rb'
  file 'db/seeds.rb', <<-RUBY
    require 'database_cleaner/active_record'

    DatabaseCleaner.allow_production = true
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    # write your new seeds after this line

  RUBY

  # Yarn
  ########################################
  run 'yarn add bootstrap @popperjs/core'
  append_file 'app/javascript/application.js', <<~JS
    import "bootstrap";
  JS

  # Dotenv
  ########################################
  run 'touch .env'

  # Rubocop
  ########################################
  file '.rubocop.yml', <<~YML
    AllCops:
      Exclude:
        - 'bin/**/*'
        - 'config/**/*'
        - 'db/migrate/**/*'
        - 'db/schema.rb'
        - 'lib/**/*'
        - 'node_modules/**/*'
        - 'tmp/**/*'
      Style/FrozenStringLiteralComment:
        Enabled: false
      Style/Documentation:
        Enabled: false
      Metrics/MethodLength:
        Max: 15
      Metrics/AbcSize:
        Max: 20
      Layout/LineLength:
        Max: 120
      Metrics/BlockLength:
        Exclude:
          - 'spec/**/*'
  YML

  # Git
  ########################################
  git :init
  git add: '.'
  git commit: "-m 'Initial commit with template from https://github.com/Naokimi/lewagon-rails-templates-plus'"
  run 'gh repo create'
end
