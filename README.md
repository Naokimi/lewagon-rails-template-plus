# Rails Template+, powered by Le Wagon
A template for Rails 7, intended to help you quickly build apps for production with a set of helpful gems. Inspired heavily by [Le Wagon's Rails Devise template](https://github.com/lewagon/rails-templates).

For the Rails 6 template please check the `rails-6` branch.

## Prerequisites:
- [Node JS](https://nodejs.org/en)
- A code editor, like [VS Code](https://code.visualstudio.com/)
- [GitHub CLI](https://cli.github.com/)


## Setup

- [**MacOS**](/setup-instructions/macos-setup.md)
- [**Linux OS**](/setup-instructions/linuxos-setup.md)
- [**Windows 11 (WSL)**](/setup-instructions/windows11-setup.md)

## Usage
1. To generate the templates, run the following command:
```
rails new \
  -d postgresql \
  -j webpack \
  -T \
  -m https://raw.githubusercontent.com/naokimi/lewagon-rails-template-plus/master/template.rb \
  CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```
(the `-j webpack` flag is optional)

## Contents
Navbar, flash messages, scss bootstrap variables, and a set of gems to help you with develoment (see list below)

### Included gems
(Starred items have been added on top of the ones used by Le Wagon's template)

- [\*annotate](https://github.com/ctran/annotate_models): Add a comment summarizing the current schema to the top or bottom of each of your models.
- [autoprefixer-rails](https://github.com/ai/autoprefixer-rails): Parse CSS and add vendor prefixes to CSS rules using values from the Can I Use database.
- [\*database_cleaner](https://github.com/DatabaseCleaner/database_cleaner): Reset ids when emptying database with seeds or rspec.
- [devise](https://github.com/heartcombo/devise): Flexible authentication solution.
- [dotenv-rails](https://github.com/bkeepers/dotenv): Shim to load environment variables from .env into ENV in development.
- [\*factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails): a fixtures replacement to help you with defining testing objects.
- [\*faker](https://github.com/faker-ruby/faker): Generate fake data for your seeds and tests.
- [font-awesome-sass](https://github.com/FortAwesome/font-awesome-sass): Sass-powered version of the web's most popular icon set and toolkit.
- [\*pundit](https://github.com/varvet/pundit): Minimal authorization through Object Oriented design and pure Ruby classes.
- [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug): Step-by-step debugging and stack navigation capabilities.
- [pry-rails](https://github.com/rweng/pry-rails): Causes `rails console` to open pry.
- [\*rspec-rails](https://github.com/rspec/rspec-rails): Behaviour Driven Development for Ruby on Rails.
- [simple_form](https://github.com/heartcombo/simple_form): Rails forms made easy.
- [\*simplecov](https://github.com/simplecov-ruby/simplecov): A tool to help you visualize how much of your app is covered by tests.
- [\*slim-rails](https://github.com/slim-template/slim-rails): Reduce HTML markup in views (no more merge conflicts on closing `</div>`s).
