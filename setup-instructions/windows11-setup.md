# Windows 11 Setup

## WSL Setup
1. Open the command terminal by pressing `Windows` + `R`
2. Type `wt` and press `ENTER`
3. Press `Ctrl` + `Shift` + `ENTER`
4. A blue terminal window will appear
5. Run the following command in the terminal:
```bash
wsl --install
```

This should install WSL 2

6. Restart your computer

7. Repen the command prompt
8. Press `Windows` + `R`
9. Type `cmd`
10. Press `ENTER`
11. Check the WSL version

```bash
wsl -l -v
```

## Connecting VSCode to Ubuntu

1. Run the following command:
```bash
code --install-extension ms-vscode-remote.remote-wsl
```

2. Open VSCode from the terminal
```bash
code .
```

## Microsoft Store Dependencies
1. From the Microsoft Store, install the [Windows Terminal](https://apps.microsoft.com/detail/Windows%20Terminal/9N0DX20HK701?hl=en-us&gl=JP)

2. From the Microsoft Store, install the latest version of Ubuntu.
As of this writing, the latest version is [Ubuntu 22.04.2 LTS](https://apps.microsoft.com/detail/Ubuntu%2022.04.2%20LTS/9PN20MSR04DW?hl=en-us&gl=JP)

3. Make Ubuntu as the default terminal
    a. Press `Ctrl`+`,` to open the terminal settings
    b. Change the default profile to `Ubuntu`
    c. Click "Save"
    d. Click "Open JSON File"
    e. Locate the entry with both `"name": "Ubuntu"`, and `"hidden": false` and add the following line after it:
        `"commandline": "wsl.exe ~"`
    f. Locate the line `"defaultProfile": "{2c4de342-...}"` and add the following line after it:
        `"multiLinePasteWarning": false,`
    g. Save the file changes

## Linking a default browser to Ubuntu

1. Select one of the following browsers and set it as the default browser

### Google Chrome

Run the following command to set Google Chrome as the Default browser:

```bash
ls /mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe
echo "export BROWSER=\"/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe\"" >> ~/.zshrc
echo "export GH_BROWSER=\"'/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe'\"" >> ~/.zshrc
```

### Firefox

Run the following command to set Mozilla Firefox as the Default browser:

```bash
ls /mnt/c/Program\ Files\ \(x86\)/Mozilla\ Firefox/firefox.exe
echo "export BROWSER=\"/mnt/c/Program Files (x86)/Mozilla Firefox/firefox.exe\"" >> ~/.zshrc
echo "export GH_BROWSER=\"'/mnt/c/Program Files (x86)/Mozilla Firefox/firefox.exe'\"" >> ~/.zshrc
```

### Microsoft Edge

Run the following command to set Microsoft Edge as the Default browser:

```bash
echo "export BROWSER='\"/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe\"'" >> ~/.zshrc
echo "export GH_BROWSER=\"'/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'\"" >> ~/.zshrc
```

2. Restart the terminal
```bash
reset
```

3. Check that the browser was successfully set
```bash
[ -z "$BROWSER" ] && echo "ERROR: please define a BROWSER environment variable ⚠️" || echo "Browser defined 👌"
```

4. Restart the terminal
```bash
reset
```

## Ruby Installation

1. Install [rbenv](https://github.com/rbenv/rbenv) to install and manage ruby environments:

```bash
sudo apt install -y build-essential tklib zlib1g-dev libssl-dev libffi-dev libxml2 libxml2-dev libxslt1-dev libreadline-dev
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
reset
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

3. Check the ruby version installed:
```bash
ruby -v
```

## Install Gems
Install gem dependencies by running the following command:

```bash
gem install colored faker http pry-byebug rake rails rest-client rspec rubocop-performance sqlite3
```

## Install Yarn
Install yarn by running the following command:

```bash
npm install --global yarn
reset
```

Check the installed yarn version
```bash
yarn -v
```