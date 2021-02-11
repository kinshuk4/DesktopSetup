#!/usr/bin/env bash
# Notes
# Using fzf instead of bash-completions

not_brews=(
  macvim
  micro
  moreutils
  mtr
  ncdu
  poppler
  postgresql
  pgcli
  osquery
  gnuplot --with-qt
  gnu-sed --with-default-names
  stormssh
  thefuck
  tmux
  tree
  trash
  vim --with-override-system-vi
  android-platform-tools
  cheat
  coreutils
  dfc
  ffmpeg
  findutils
  fontconfig --universal
  fpp
  fzf
  go
  hh
  htop
  httpie
  iftop
  imagemagick --with-webp
  lame
  lighttpd
  lnav
  nmap
  node
  readline
  xz
)
brews=(
  awscli
  curl
  git
  git-extras
  git-lfs
  isyncr-desktop
  mackup
  maven
  mas
  python3
  sbt
  scala
  sqlite
  tunnelblick
  wget --with-iri
)

not_casks=(
  airdroid
  atom 
  cakebrew
  commander-one
  datagrip
  cleanmymac
  geekbench  
  istat-menus
  istat-server 
  licecap
  iterm2
  betterzipql
  qlcolorcode
  qlmarkdown
  qlstephen
  quicklook-json
  quicklook-csv
  macdown
  microsoft-office
  osxfuse
  plex-home-theater
  plex-media-server
  private-eye
  satellite-eyes
  sidekick
  sling
  volumemixer
  webstorm
  xquartz
  tunnelbear
  spotify
  steam
  teleport
  ticktick
  transmission
  transmission-remote-gui  
)
casks=(
  adobe-reader 
  android-studio
  box-drive
  be-focused
  beyond-compare
  calibre
  clion
  dropbox
  evernote
  firefox
  google-chrome
  google-drive-file-stream
  google-backup-and-sync
  github-desktop
  hipchat
  hosts  
  intellij-idea  
  keka 
  kindle
  launchrocket
  onedrive
  postman
  opera
  pocket
  skype
  slack  
  tunnelbear
  typora
  visual-studio-code
  vlc  
  whatsapp
  xmind
)

pips=(
  pip
  cryptography
  requests
  six  
)

not_gems=(
  bundle
  fenix-cli
  gitjk
  kill-tabs
  n
  nuclide-installer
)

gems=(

)

not_npms=(

)

npms=(
  
)

not_git_configs=(
  gpg_key='3E219504'
  "branch.autoSetupRebase always"
  "color.ui auto"
  "core.autocrlf input"
  "core.pager cat"
  "credential.helper osxkeychain"
  "merge.ff false"
  "pull.rebase true"
  "push.default simple"
  "rebase.autostash true"
  "rerere.autoUpdate true"
  "rerere.enabled true"
  "user.name pathikrit"
  "user.email pathikritbhowmick@msn.com"
  "user.signingkey ${gpg_key}"
)
git_configs=(

)


apms=(
  atom-beautify
  circle-ci
  ensime
  intellij-idea-keymap
  language-scala
  minimap
)

vscode=(
  donjayamanne.python
  dragos.scala-lsp
  lukehoban.Go
  ms-vscode.cpptools
  rebornix.Ruby
  redhat.java
)

not_fonts=(
  font-source-code-pro
)

fonts=(
  
)

mac_apps=(
  copyclip
  feedlycode 
  houseparty
  pocket
  spark
)

setup_npm=false
setup_java=true
setup_atom=false
setup_vs_code=true
setup_pip=true
setup_conda=true

######################################## End of app list ########################################
set +e
set -x


function prompt {
  read -p "Hit Enter to $1 ..."
}

if test ! $(which brew); then
  echo "Install Xcode"
  xcode-select --install

  echo "Install Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"  
else
  echo "Update Homebrew"
  brew update
  brew upgrade
fi
brew doctor
brew tap homebrew/dupes

function install {
  cmd=$1
  shift
  for pkg in $@;
  do
    exec="$cmd $pkg"
    echo "Execute: $exec"
    if ${exec} ; then
      echo "Installed $pkg"
    else
      echo "Failed to execute: $exec"
    fi
  done
}

function mac_install {
  for pkg in $@;
  do
    exec = "mas install $(mas search $pkg | head -1 | cut -f 1  -d ' ')"
    echo "Execute: $exec"
    if ${exec} ; then
      echo "Installed $pkg"
    else
      echo "Failed to execute: $exec"
    fi
}

if $setup_npm; then
  prompt "Update ruby"
  ruby -v
  brew install gpg
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | bash -s stable
  ruby_version='2.6.0'
  rvm install ${ruby_version}
  rvm use ${ruby_version} --default
  ruby -v
  sudo gem update --system
fi

if $setup_java; then
  echo "Install Java"
  brew cask install java
fi


echo "Install packages"
brew info ${brews[@]}
install 'brew install' ${brews[@]}

echo "Install software"
brew tap caskroom/versions
brew cask info ${casks[@]}
install 'brew cask install' ${casks[@]}

echo "Installing secondary packages"
install 'pip install --upgrade' ${pips[@]}
install 'gem install' ${gems[@]}
install 'npm install --global' ${npms[@]}


if $setup_atom; then
  install 'apm install' ${apms[@]}
fi

if $setup_vs_code; then
  install 'code --install-extension' ${vscode[@]}
fi

if $setup_fonts; then
  brew tap caskroom/fonts
  install 'brew cask install' ${fonts[@]}
fi



if $upgrade_bash; then
  prompt "Upgrade bash"
  brew install bash
  sudo bash -c "echo $(brew --prefix)/bin/bash >> /private/etc/shells"
  mv ~/.bash_profile ~/.bash_profile_backup
  mv ~/.bashrc ~/.bashrc_backup
  mv ~/.gitconfig ~/.gitconfig_backup
  cd; curl -#L https://github.com/barryclark/bashstrap/tarball/master | tar -xzv --strip-components 1 --exclude={README.md,screenshot.png}
  source ~/.bash_profile
fi


if $setup_git; then
  prompt "Set git defaults"
  for config in "${git_configs[@]}"
  do
    git config --global ${config}
  done
  gpg --keyserver hkp://pgp.mit.edu --recv ${gpg_key}
fi

if $setup_mac_cli; then
  echo "Install mac CLI [NOTE: Say NO to bash-completions since we have fzf]!"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"
fi


if $setup_pip; then
  echo "Get pip"
  sudo easy_install pip
  echo "Update packages"
fi

pip3 install --upgrade pip setuptools wheel

if $setup_conda; then
  echo "Installing miniconda for python3"
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
  bash Miniconda3-latest-MacOSX-x86_64.sh
  # echo "Setting up the sdcnd environment"
  # git clone https://github.com/udacity/CarND-Term1-Starter-Kit.git
  # cd CarND-Term1-Starter-Kit
  # conda env create -f environment.yml
  # conda clean -tp
  # cd ..
  # rm -rf CarND-Term1-Starter-Kit
  conda update --all
fi


echo "zalando specific"

echo "Trying to upgrade mac"
mac update

echo install pocket,houseparty


echo "Mac applications"
mac_install ${mac_apps[@]}


prompt "Cleanup"
brew cleanup
brew cask cleanup

#cp ~/Lyf/Syncs/Dropbox/AppsMisc/Apps4Mac/Preferences/com.apple.dock.plist ~/Library/Preferences/


read -p "Run `mackup restore` after DropBox has done syncing ..."
echo "Done!"
