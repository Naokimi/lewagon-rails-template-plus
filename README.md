# Rails Template+, powered by Le Wagon
A template for Rails 8, intended to help you quickly build apps for production with a set of helpful gems. Inspired heavily by [Le Wagon's Rails Devise template](https://github.com/lewagon/rails-templates).

For the Rails 7 template please check the `rails-7` branch.
For the Rails 6 template please check the `rails-6` branch.

## Prerequisites:
- [Node JS](https://nodejs.org/en)
- A code editor, like [VS Code](https://code.visualstudio.com/)
- [Github CLI](https://cli.github.com/)

## Usage
1. To generate the templates, run the following command:
```
rails new \
  --css=bootstrap \
  -T \
  -m https://raw.githubusercontent.com/naokimi/lewagon-rails-template-plus/master/template.rb \
  CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```
(Rails 8 has been designed for sqlite3. Remémber to pass `-d <database>` is you want to use a different database.)

Run your generated application with `./bin/dev`

## Contents
Navbar, flash messages, scss bootstrap variables, and a set of gems to help you with develoment (see list below)

### Included gems
(Starred items have been added on top of the ones used by Le Wagon's template)

- [autoprefixer-rails](https://github.com/ai/autoprefixer-rails): Parse CSS and add vendor prefixes to CSS rules using values from the Can I Use database.
- [\*database_cleaner](https://github.com/DatabaseCleaner/database_cleaner): Reset ids when emptying database with seeds or rspec.
- [devise](https://github.com/heartcombo/devise): Flexible authentication solution.
- [dotenv-rails](https://github.com/bkeepers/dotenv): Shim to load environment variables from .env into ENV in development.
- [\*factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails): a fixtures replacement to help you with defining testing objects.
- [\*faker](https://github.com/faker-ruby/faker): Generate fake data for your seeds and tests.
- [\*pundit](https://github.com/varvet/pundit): Minimal authorization through Object Oriented design and pure Ruby classes.
- [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug): Step-by-step debugging and stack navigation capabilities.
- [pry-rails](https://github.com/rweng/pry-rails): Causes `rails console` to open pry.
- [\*rspec-rails](https://github.com/rspec/rspec-rails): Power testing library for Ruby on Rails.
- [simple_form](https://github.com/heartcombo/simple_form): Rails forms made easy.
- [\*simplecov](https://github.com/simplecov-ruby/simplecov): A tool to help you visualize how much of your app is covered by tests.
- [\*slim-rails](https://github.com/slim-template/slim-rails): Reduce HTML markup in views (no more merge conflicts on closing `</div>`s).
