unsupported_version = 7
if Rails.version >= unsupported_version
  puts '-----------------'
  puts "This template doesn't support Rails version #{unsupported_version} and above"
  puts '-----------------'
  return
end

run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"

# GEMFILE
########################################
gem 'autoprefixer-rails', '10.2.5'
gem 'database_cleaner-active_record'
gem 'devise'
gem 'faker'
gem 'font-awesome-sass'
gem 'pundit'
gem 'simple_form'
gem 'slim-rails'

gem_group :development, :test do
  gem 'annotate'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
end

gem_group :test do
  gem 'simplecov', require: false
end

gsub_file('Gemfile', /# gem 'redis'/, "gem 'redis'")

# Assets
########################################
run 'rm -rf app/assets/stylesheets'
run 'rm -rf vendor'
# check if we might want to import our own stylesheets
run 'curl -L https://github.com/lewagon/rails-stylesheets/archive/master.zip > stylesheets.zip'
run 'unzip stylesheets.zip -d app/assets && rm stylesheets.zip && mv app/assets/rails-stylesheets-master app/assets/stylesheets'

# Dev environment
########################################
gsub_file('config/environments/development.rb', /config\.assets\.debug.*/, 'config.assets.debug = false')

# Layout
########################################
run 'rm app/views/layouts/application.html.erb'

file 'app/views/layouts/application.html.slim', <<~HTML
  doctype html
  html
    head
      title LoadingPrep
      meta name="viewport" content="width=device-width,initial-scale=1"
      = csrf_meta_tags
      = csp_meta_tag

      meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"
      = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'

      = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload', defer: true

    body
      = render 'shared/navbar'
      = render 'shared/flashes'

      .container
        = yield

      = render 'shared/footer'

HTML

# Flashes
########################################
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

  # Replace simple form initializer to work with Bootstrap 5
  run 'curl -L https://raw.githubusercontent.com/heartcombo/simple_form-bootstrap/main/config/initializers/simple_form_bootstrap.rb > config/initializers/simple_form_bootstrap.rb'

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
  file 'spec/support/factories/user.rb', <<~RUBY
    FactoryBot.define do
      factory :user do
        email    { 'gmail@chucknorris.com' }
        password { 'roundhousekick' }
      end
    end
  RUBY

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

  # Webpacker / Yarn
  ########################################
  run 'yarn add bootstrap @popperjs/core'
  run 'rails webpacker:install:stimulus'
  append_file 'app/javascript/packs/application.js', <<~JS
    import "bootstrap";
  JS

  inject_into_file 'config/webpack/environment.js', before: 'module.exports' do
    <<~JS
      // Preventing Babel from transpiling NodeModules packages
      environment.loaders.delete('nodeModules');
    JS
  end

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
  git add: '.'
  git commit: "-m 'Initial commit with template from https://github.com/Naokimi/lewagon-rails-templates-plus'"
  run 'gh repo create'
end
