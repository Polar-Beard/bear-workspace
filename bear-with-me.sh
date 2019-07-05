#!/bin/bash -eu

set -o pipefail

default='39m'
blue='34m'
cyan='36m'
green='32m'

#Takes two arguments
# 1: Component
# 2: Message
function step() {
  local component="${1}"
  local message="${2}"

  echo -e "\e[${blue}${component}: \e[${cyan}${message}\n\e[${default}"
}


# Takes two arguments
# 1: The file to update
# 2: The original line
# 3: The new line (optional, if just adding)
function updateFile(){
  local file="${1}"
  local line="${2}"
  local newLine=${3:-""}

  if [ ! -f "${file}" ]; then
    touch "${file}"
  fi

  if grep --fixed-strings --quiet "${line}" "${file}"; then
    if [[ "${newLine}" != "" ]]; then
      sed -i "s/^${line}.*/${newLine}/" "${file}"
    else
      printf "${file} already contains \n${line}\n. Doing nothing"
    fi
  else
    local temp="$(mktemp --directory)/file"
    echo "${line}" | cat - "${file}" > "${temp}"
    mv "${temp}" "${file}"
  fi
}

# Takes 1 argument
# 1: package to install
function aptGetInstall() {
	local package="${1}"
	if ! dpkg -s "${package}" &>/dev/null ; then
		step apt-get "installing ${package}"
		sudo apt-get install "${package}" -y
	fi
}

function installPPA() {
	aptGetInstall "software-properties-common"
	if ! grep --quiet "neovim-ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
		step "add-apt-repository" "add neovim ppa"
		sudo add-apt-repository ppa:neovim-ppa/stable -y
		sudo apt-get update
	fi
}

function setNvimAsAlternatives() {
	step "update-alternatives" "setting neovim as alternatives"
	sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
	sudo update-alternatives --config vi --skip-auto
	sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
	sudo update-alternatives --config vim --skip-auto
	sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
	sudo update-alternatives --config editor --skip-auto
}

# Takes two arguments
# 1: Install Path
# 2: Git Repo
function gitClone() {
	local path="${1}"
	local repo="${2}"

	if [ ! -d ${path} ]; then
		step "git" "cloning ${repo}"
		git clone "${repo}" ${path}
	fi
}

function installYarnDl() {
	if ! grep --quiet "yarn" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
		step "apt-get" "install yarn PPA"
		curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
		echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
		sudo apt-get update
	fi
}

function link() {
  local original_file="$1"
  local linked_file="$2"

  if [ ! -f ${linked_file} ]; then
    step "link" "${linked_file}"
    ln -s "${original_file}" "${linked_file}"
  fi
}

function main() {

# Neovim needs a custom PPA. See https://github.com/neovim/neovim/wiki/Installing-Neovim
installPPA
# Yarn needs a custom thing too. See https://linuxize.com/post/how-to-install-yarn-on-ubuntu-18-04/
installYarnDl

declare -a packages=(
  "zsh"
  "neovim"
  "python-dev"
  "python-pip"
  "python3-dev"
  "python3-pip"
  "nodejs"
  "npm"
  "yarn"
)

for package in "${packages[@]}";
do
  aptGetInstall "${package}"
done

declare -a pipPackages=(
  "pynvim"
  "pipenv"
)

for package in "${pipPackages[@]}"
do
  pip3 install --user "${package}"
done

step "update file" 'adding zsh to ~/.bashrc'
updateFile "${HOME}/.bashrc" 'bash -c zsh'

if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  step "curl" "downloading and installing oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

link "${PWD}/gitconfig" "${HOME}/.gitconfig"
link "${PWD}/zshrc" "${HOME}/.zshrc"
link "${PWD}/aliases.zsh" "${HOME}/.oh-my-zsh/custom/aliases.zsh"

local zsh_syntax_highlighting_path="${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
gitClone "${zsh_syntax_highlighting_path}" "https://github.com/zsh-users/zsh-syntax-highlighting.git"

setNvimAsAlternatives
local nvim_config_path="${HOME}/.config/nvim"
gitClone "${nvim_config_path}" "https://github.com/luan/nvim"

if [ -z $(which go) ]; then
  step "install" "go cli"
  download_location="$(mktemp --directory)/go.tgz"
  curl --fail --output "${download_location}" "https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz"
  sudo tar -C '/usr/local' -xzf "${download_location}"
  rm "${download_location}"
fi

if [ ! -d  "${HOME}/workspace" ]; then
  step "mkdir" "making workspace"
  mkdir "${HOME}/workspace"
fi

if [ ! -d  "${HOME}/workspace/go" ]; then
  step "mkdir" "making gopath"
  mkdir "${HOME}/workspace/go"
fi

echo -e "\e[${green}\n"
cat <<-'EOF'
$$\     $$\                         $$$$$$$\
\$$\   $$  |                        $$  __$$\
 \$$\ $$  /$$$$$$\  $$\   $$\       $$ |  $$ | $$$$$$\   $$$$$$\  $$$$$$$\ 
  \$$$$  /$$  __$$\ $$ |  $$ |      $$$$$$$\ |$$  __$$\ $$  __$$\ $$  __$$\ 
   \$$  / $$ /  $$ |$$ |  $$ |      $$  __$$\ $$$$$$$$ |$$$$$$$$ |$$ |  $$ |
    $$ |  $$ |  $$ |$$ |  $$ |      $$ |  $$ |$$   ____|$$   ____|$$ |  $$ |
    $$ |  \$$$$$$  |\$$$$$$  |      $$$$$$$  |\$$$$$$$\ \$$$$$$$\ $$ |  $$ |
    \__|   \______/  \______/       \_______/  \_______| \_______|\__|  \__|



$$$$$$$\  $$$$$$$$\  $$$$$$\  $$$$$$$\  $$$$$$$$\ $$$$$$$\ 
$$  __$$\ $$  _____|$$  __$$\ $$  __$$\ $$  _____|$$  __$$\ 
$$ |  $$ |$$ |      $$ /  $$ |$$ |  $$ |$$ |      $$ |  $$ |
$$$$$$$\ |$$$$$\    $$$$$$$$ |$$$$$$$  |$$$$$\    $$ |  $$ |
$$  __$$\ $$  __|   $$  __$$ |$$  __$$< $$  __|   $$ |  $$ |
$$ |  $$ |$$ |      $$ |  $$ |$$ |  $$ |$$ |      $$ |  $$ |
$$$$$$$  |$$$$$$$$\ $$ |  $$ |$$ |  $$ |$$$$$$$$\ $$$$$$$  |
\_______/ \________|\__|  \__|\__|  \__|\________|\_______/

EOF
echo -e "\e[${default}"
}

main "$@"
