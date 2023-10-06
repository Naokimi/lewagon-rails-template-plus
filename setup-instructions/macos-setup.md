# MacOS Setup

## MacOS Dependencies
1. Make sure you have [homebrew](https://docs.brew.sh/Installation) installed

2. Install [zsh](https://ohmyz.sh/#install) and set it as the default shell

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Ruby Installation
1. Install [rbenv](https://github.com/rbenv/rbenv) to install and manage ruby environments:

```bash
brew install rbenv ruby-install
```

2. Install the latest ruby version via rbenv and set it as the default version.
The latest stable version is [3.2.2](https://www.ruby-lang.org/en/downloads/)

```bash
# install 3.2.2
rbenv install 3.2.2
# set the global version to 3.2.2
rbenv global 3.2.2
# set the local version to 3.2.2
rbenv local 3.2.2
# set the system version to 3.2.2
rbenv shell 3.2.2
```

3. Restart the terminal

```bash
exec zsh
```

4. Check the current ruby version:

```bash
ruby -v
```

## Gem Installation

Install some external libraries via [gems](https://rubygems.org/):

```bash
gem update --system
gem install bundler
bundle update
bundle install
gem install colored faker http pry-byebug rake rails rest-client rspec rubocop-performance sqlite3
```

## Yarn Installation

Install [yarn](https://yarnpkg.com/) to manage Javascript libraries and restart the terminal:

```bash
npm install --global yarn
exec zsh
```

Check the correct version is installed:

```bash
yarn -v
```