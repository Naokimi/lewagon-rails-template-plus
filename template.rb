run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"

# GEMFILE
########################################
gem 'autoprefixer-rails', '10.2.5'
gem 'database_cleaner-active_record'
gem 'devise'
gem 'faker'
gem 'font-awesome-sass'
gem 'pundit'
gem 'slim-rails'
gem 'simple_form'

gem_group :development, :test do
  gem 'annotate'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec'
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

      div class="container"
        = yield

HTML

# Flashes
########################################
file 'app/views/shared/_flashes.html.slim', <<~HTML
  - if notice
    .alert.alert-info.alert-dismissible.fade.show.m-1 role="alert"
      = notice
      button.close type="button" data-dismiss="alert" aria-label="Close"
        span aria-hidden="true" &times;
  - if alert
    .alert.alert-warning.alert-dismissible.fade.show.m-1 role="alert"
      = alert
      button.close type="button" data-dismiss="alert" aria-label="Close"
        span aria-hidden="true" &times;
HTML

# rewrite from scratch
run 'curl -L https://github.com/lewagon/awesome-navbars/raw/master/templates/_navbar_wagon.html.erb > app/views/shared/_navbar.html.erb'

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
  end
RUBY

environment generators

########################################
# AFTER BUNDLE
########################################
after_bundle do
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

  # migrate + devise views
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
  run 'yarn add bootstrap'
  append_file 'app/javascript/packs/application.js', <<~JS
    // ----------------------------------------------------
    // Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
    // WRITE YOUR OWN JS STARTING FROM HERE 👇
    // ----------------------------------------------------
    // External imports
    import "bootstrap";
    // Internal imports, e.g:
    // import { initSelect2 } from '../components/init_select2';
    document.addEventListener('turbolinks:load', () => {
      // Call your functions here, e.g:
      // initSelect2();
    });
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
  git add: '.'
  git commit: "-m 'Initial commit with template from https://github.com/Naokimi/lewagon-rails-templates-plus'"
  run 'gh repo create'
end
