# modify rubocop rule to ignore toplevel documentation

supported_version = 8
unless Rails.version.to_i == supported_version
  puts '-----------------'
  puts "This template supports only Rails version #{supported_version}."
  puts "Try using the template from branch `rails-#{Rails.version.to_i}`."
  puts '-----------------'
  return
end

run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"

# GEMFILE
########################################
gem 'autoprefixer-rails'
gem 'database_cleaner-active_record'
gem 'devise'
gem 'faker'
gem 'pundit'
gem 'simple_form', github: 'heartcombo/simple_form'
gem 'slim-rails'

gem_group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
end

gem_group :test do
  gem 'simplecov', require: false
end

# Assets
########################################
run 'rm -rf app/assets/stylesheets'
run 'rm -rf vendor'
# check if we might want to import our own stylesheets
run 'curl -L https://github.com/lewagon/rails-stylesheets/archive/master.zip > stylesheets.zip'
run 'unzip stylesheets.zip -d app/assets && rm stylesheets.zip && mv app/assets/rails-stylesheets-master app/assets/stylesheets'

# Dev environment
########################################
environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'
environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }', env: 'production'

# Layout
########################################
run 'rm app/views/layouts/application.html.erb'

file 'app/views/layouts/application.html.slim', <<~HTML
  doctype html
  html
    head
      title = content_for(:title) || "Rails Template App"
      meta name="viewport" content="width=device-width,initial-scale=1"
      meta name="apple-mobile-web-app-capable" content="yes"
      meta name="mobile-web-app-capable" content="yes"
      = csrf_meta_tags
      = csp_meta_tag

      = yield :head

      // Enable PWA manifest for installable apps (make sure to enable in config/routes.rb too!)
      // = tag.link rel: "manifest", href: pwa_manifest_path(format: :json)

      link rel="icon" href="/icon.png" type="image/png"
      link rel="icon" href="/icon.svg" type="image/svg+xml"
      link rel="apple-touch-icon" href="/icon.png"

      // Includes all stylesheet files in app/assets/stylesheets
      = stylesheet_link_tag :app, "data-turbo-track": "reload"
      = javascript_importmap_tags

    body
      = render 'shared/navbar'
      = render 'shared/flashes'

      .container
        = yield

      = render 'shared/footer'

HTML

# Shared HTML Files
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
  environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }',
              env: 'production'

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

  # Bootstrap + Stylesheet Config
  ########################################
  run 'rm app/assets/stylesheets/application.scss app/assets/stylesheets/application.bootstrap.scss'
  # run 'rm app/assets/stylesheets/application.bootstrap.scss'
  file 'app/assets/stylesheets/application.bootstrap.scss', <<~CSS
    // Graphical variables
    @import "config/fonts";
    @import "config/colors";
    @import "config/bootstrap_variables";

    @import 'bootstrap/scss/bootstrap';
    @import 'bootstrap-icons/font/bootstrap-icons';

    // Your CSS partials
    @import "components/index";
    @import "pages/index";
  CSS

  inject_into_file 'config/initializers/assets.rb',
                   after: '# Rails.application.config.assets.paths << Emoji.images_path' do
    <<~RUBY
      Rails.application.config.assets.paths << Rails.root.join("node_modules")
      Rails.application.config.assets.precompile << "bootstrap.bundle.min.js"
    RUBY
  end

  # Dotenv
  ########################################
  run 'touch .env'

  # Rubocop
  ########################################
  run 'rm .rubocop.yml'
  file '.rubocop.yml', <<~YML
    # Omakase Ruby styling for Rails
    inherit_gem: { rubocop-rails-omakase: rubocop.yml }

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
  run 'rubocop -a'
  git add: '.'
  git commit: "-m 'Initial commit with template from https://github.com/Naokimi/lewagon-rails-templates-plus'"
  run 'gh repo create'
end
