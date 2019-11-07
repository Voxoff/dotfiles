
###############################################################
# Script to install stuff for new laptop.
#
# Xcode, Brew, git, rvm, ruby 2.6.1, gems, sqlite3, postgres
# chrome, slack, spotify, shiftit, powerline, zsh, firefox?
# vscode, sublime
#
###############################################################
create_variable_and_install() {
  suffix=$1
  declare check_$suffix="[ -f /Applications/$1.app/Contents/MacOS/$1 ]"
  varname=check_$suffix
}

# extract strings - most are used in both checker script and installer script
check_xcode='type xcode-select >&- && xpath=$( xcode-select --print-path ) && test -d "${xpath}" && test -x "${xpath}"'
check_brew="command -v brew >/dev/null 2>&1"
check_git="command -v git >/dev/null 2>&1 && git version | grep -q 'git version'"
check_git_user="command -v git >/dev/null 2>&1 && git config --list | grep -q 'github.user='"
check_git_email="command -v git >/dev/null 2>&1 && git config --list | grep -q 'github.email='"
check_brew_gmp="command -v brew >/dev/null 2>&1 && brew list | grep -q 'gmp'"
check_brew_gnupg="command -v brew >/dev/null 2>&1 && brew list | grep -q 'gnupg'"
check_rvm="command -v rvm >/dev/null 2>&1 && which rvm | grep -q '/Users/.*/\.rvm/bin/rvm'"
check_ruby_version="command -v rvm >/dev/null 2>&1 && rvm list | grep -Fq '=* ruby-2.6.1 [ x86_64 ]'"
check_rvm_path="command -v rvm >/dev/null 2>&1 && rvm list | grep -Fqv 'Warning! PATH'"
check_bundler="command -v gem >/dev/null 2>&1 && gem list | grep -q 'bundler'"
check_nokogiri="command -v gem >/dev/null 2>&1 && gem list | grep -q 'nokogiri'"
check_rails_gem="command -v gem >/dev/null 2>&1 && gem list | grep -q 'rails'"
check_rails="command -v rails >/dev/null 2>&1 && rails --version | grep -q 'Rails'"
check_sqlite3="command -v sqlite3 >/dev/null 2>&1"
check_postgres="command -v postgres >/dev/null 2>&1 && postgres --version | grep -q 'postgres (PostgreSQL)'"
check_psql="command -v psql >/dev/null 2>&1 && psql --version | grep -q 'psql (PostgreSQL)'"
check_chrome="[ -f /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome ]"
check_slack="[ -f /Applications/Slack.app/Contents/MacOS/Slack ]"
check_spotify="[ -f /Applications/Spotify.app/Contents/MacOS/Spotify ]"
check_postman="[ -f /Applications/Postman.app/Contents/MacOS/Postman ]"

# homebrew
if ! eval $check_brew; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
fi

# general brew packages
function install_or_upgrade { brew ls | grep $1 > /dev/null; if (($? == 0)); then brew upgrade $1; else brew install $1; fi }

packages=("git" "wget" "gmp" "gnupg" "sqlite" "imagemagick" "jq" "openssl" "tree" "tmux" "zsh" "nmap" "htop" "watch")
for package in $packages; do install_or_upgrade $package; done

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# Ruby version
# vers=2.6.1
html = Net::HTTP.get(URI("https://www.ruby-lang.org/en/downloads/"))
vers = html[/http.*ruby-(.*).tar.gz/,1]
if ! eval $check_rvm_path; then
  # needed for rvm use
  if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    . "$HOME/.rvm/scripts/rvm"
    rvm use $vers
  else
    echo "$HOME/.rvm/scripts/rvm" could not be found. Will proceed to install it.
  fi
fi

if ! eval $check_rvm; then
  curl -sSL https://get.rvm.io | bash
  # work around so you dont have to close and reopen terminal
  if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    . "$HOME/.rvm/scripts/rvm"
  else
    echo "$HOME/.rvm/scripts/rvm" could not be found.
  fi
  export PATH="$PATH:$HOME/.rvm/bin"
  echo "You now have rvm (that's ruby version manager)"
fi

if ! eval $check_ruby_version; then
  # necessary for rvm to become a shell function, and so to run rvm use...
  source  ~/.rvm/scripts/rvm
  rvm use $vers --default --install
  echo "You now have ruby $vers. Good move!"
fi

gem update --system
gems=("prawn" "bundler" "json" "rspec" "pry" "pry-byebug" "sqlite3" "nokogiri" "hub" "thin" "shotgun" "rack" "hotloader" "rails" "sinatra")
source  ~/.rvm/scripts/rvm
for gem in ${gems}; do
  ! eval "command -v gem >/dev/null 2>&1 && gem list | grep -q $gem" && gem install $gem --no-document && echo "installed $gem"
done


# Cask for slack google and atom
! eval $check_postman && brew cask install postman
! eval $check_chrome && brew cask install google-chrome
! eval $check_slack && brew cask install slack


# I have not built in checks yet.

cask_packages=("spotify" "hyper" "docker" "iterm2" "vlc" "firefox" "sublime-text" "alfred" "insomnia" "1password" "flux" "shiftit" "visual-studio-code")
for cask in $cask_packages; do brew cask install $cask; done

source ~/.nvm/nvm.sh
if ! eval $check_nvm; then
  curl -so- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
  echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bash_profile
  echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ~/.bash_profile
  source ~/.bash_profile
fi

if ! eval $check_node; then
  nvm install node
  nvm use node
  nvm alias default node
fi

if ! eval $check_postgres; then
  brew install postgresql
  ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
  export alias pg_start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
  pg_start
fi

defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15


#Needs chceker for the fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts














###################################################################################
# THE CHECKER
###################################################################################

# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'


# https://stackoverflow.com/questions/5615717/how-to-store-a-command-in-a-variable-in-linux
# https://stackoverflow.com/questions/17336915/return-value-in-a-bash-function
# $1 => Command to run
evaluate_test () {
  # https://stackoverflow.com/questions/11193466/echo-without-newline-in-a-shell-script
  eval $1 && printf "${GREEN}pass${NC}\n" || printf "${RED}fail${NC}\n"
}

# $1 => Test Name
# $2 => Command to run
print_table_results () {
  local result=$(evaluate_test "$2")
  # https://stackoverflow.com/questions/6345429/how-do-i-print-some-text-in-bash-and-pad-it-with-spaces-to-a-certain-width
  printf "%-30s => [ %-6s ]\n" "$1" "$result"
}

# $1 => Test Name
# $2 => Command to run
print_data_row () {
  local result=$(eval "$2")
  printf "%-12s => [ %-6s ]\n" "$1" "$result"
}

delimiter () {
  printf "${BLUE}******************************************${NC}\n"
}

validation_header () {
  printf "\n${CYAN}************ VALIDATING SETUP ************${NC}\n\n"
}

configuration_header () {
  printf "\n${CYAN}************* CONFIGURATION **************${NC}\n\n"
}


## Validation
validation_header
delimiter


## 2. Xcode Command Line Tools
# https://apple.stackexchange.com/questions/219507/best-way-to-check-in-bash-if-command-line-tools-are-installed
# https://stackoverflow.com/questions/15371925/how-to-check-if-command-line-tools-is-installed
# https://stackoverflow.com/questions/21272479/how-can-i-find-out-if-i-have-xcode-commandline-tools-installed
print_table_results "Xcode Command Line Tools" $check_xcode
delimiter

## 4. Homebrew
# https://stackoverflow.com/questions/21577968/how-to-tell-if-homebrew-is-installed-on-mac-os-x
# https://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
print_table_results "Homebrew" $check_brew
delimiter

## 5. git
# https://stackoverflow.com/questions/12254076/how-do-i-show-my-global-git-config
print_table_results "Installed git" $check_git
print_table_results "Github user config" $check_git_user
print_table_results "Github email config" $check_git_email
delimiter

## 6. Support Libraries
print_table_results "Installed gmp" $check_gmp
print_table_results "Installed gnupg" $check_gnupg
delimiter

## 7. Ruby Version Manager (rvm)
print_table_results "Installed RVM" $check_rvm
print_table_results "Default RVM (2.6.1)" $check_ruby_version
print_table_results "Test RVM PATH" $check_rvm_path
delimiter

## 8. Gems
print_table_results "Gem: learn-co" $check_learn
print_table_results "Gem: bundler" $check_bundler
delimiter

## 10. Atom
print_table_results "Installed Atom" $check_atom
delimiter

## 11. Gems (more)
print_table_results "Gem: nokogiri" $check_nokogiri
delimiter

## 12. Databases
print_table_results "Installed sqlite" $check_sqlite
print_table_results "Installed PostgreSQL" $check_postgresql
print_table_results "Installed psql" $check_psql
delimiter

## 13. Rails
print_table_results "Installed Rails" $check_rails
print_table_results "Gem: rails" $check_rails_gem
delimiter


## 16. Google Chrome
# https://unix.stackexchange.com/questions/63387/single-command-to-check-if-file-exists-and-print-custom-message-to-stdout
# Cant put this in a variable because it escapes the [] and I have no time
print_table_results "Installed Google Chrome" "[ -f /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome ] && /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version | grep -q 'Google Chrome'"
delimiter

## 17. Slack
# Cant put this in a variable because it escapes the [] and I have no time
print_table_results "Installed Slack" "[ -f /Applications/Slack.app/Contents/MacOS/Slack ] && /Applications/Slack.app/Contents/MacOS/Slack --version | grep -q ''"
delimiter

