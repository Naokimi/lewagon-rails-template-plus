#  Linux OS Setup

## Linux Dependencies
Install some dependencies
```bash
sudo apt install -y build-essential tklib zlib1g-dev libssl-dev libffi-dev libxml2 libxml2-dev libxslt1-dev libreadline-dev
```

## Ruby Installation

1. Install [rbenv](https://github.com/rbenv/rbenv) to install and manage ruby environments:

```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

2. Restart the terminal
```bash
reset
```

3. Install the latest ruby version via rbenv and set it as the default version.
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

4. Restart the terminal

```bash
reset
```

5. Check the current ruby version to see if it was properly installed:

```bash
ruby -v
```

## Install Gems

Install some external libraries via [gems](https://rubygems.org/):

```bash
gem install colored faker http pry-byebug rake rails rest-client rspec rubocop-performance sqlite3
```

## Install Yarn

Install [yarn](https://yarnpkg.com/) to manage Javascript libraries and restart the terminal:

```bash
npm install --global yarn
```

Check the correct version is installed:

```bash
yarn -v
```