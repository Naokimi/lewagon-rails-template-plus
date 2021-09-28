# Rails Template+, powered by Le Wagon
A template for Rails 6, intended to help you quickly build apps for production with a lot of helpful gems. Inspired heavily by [Le Wagon's Rails Devise template](https://github.com/lewagon/rails-templates).

### Usage
run 
```
rails new APP-NAME -d=postgresql -m https://raw.githubusercontent.com/naokimi/rails-multiUIs-template/master/template.rb
```

## Contents
Navbar, flash messages, scss bootstrap variables, and a set of gems to help you with develoment (see list below)

### Included gems
(Starred items have been added on top of the ones used by Le Wagon's template)

- [annotate\*](https://github.com/ctran/annotate_models): Add a comment summarizing the current schema to the top or bottom of each of your models.
- [autoprefixer-rails](https://github.com/ai/autoprefixer-rails): Parse CSS and add vendor prefixes to CSS rules using values from the Can I Use database.
- [database_cleaner\*](https://github.com/DatabaseCleaner/database_cleaner): Reset ids when emptying database with seeds or rspec.
- [devise](https://github.com/heartcombo/devise): Flexible authentication solution.
- [dotenv-rails](https://github.com/bkeepers/dotenv): Shim to load environment variables from .env into ENV in development.
- [factory_bot_rails\*](https://github.com/thoughtbot/factory_bot_rails): a fixtures replacement to help you with defining testing objects.
- [faker\*](https://github.com/faker-ruby/faker): Generate fake data for your seeds and tests.
- [font-awesome-sass](https://github.com/FortAwesome/font-awesome-sass): Sass-powered version of the web's most popular icon set and toolkit.
- [pundit](https://github.com/varvet/pundit): Minimal authorization through Object Oriented design and pure Ruby classes.
- [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug): Step-by-step debugging and stack navigation capabilities.
- [pry-rails](https://github.com/rweng/pry-rails): Causes `rails console` to open pry.
- [rspec-rails\*](https://github.com/rspec/rspec-rails): Behaviour Driven Development for Ruby on Rails.
- [simple_form](https://github.com/heartcombo/simple_form): Rails forms made easy.
- [simplecov\*](https://github.com/simplecov-ruby/simplecov): A tool to help you visualize how much of your app is covered by tests.
- [slim-rails\*](https://github.com/slim-template/slim-rails): Reduce markdown in views (no more merge conflicts on closing `</div>`s).
