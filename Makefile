DOTFILES=${HOME}/.dotfiles

# Arguments to pass to make
apple: brew stow neovim zplug

linux: linuxrepo debian stow fnm neovim zplug linuxzsh

brew:
	brew bundle

fzf:
	/usr/local/opt/fzf/install --all --no-bash --no-fish

neovim:
	python3 -m pip install --upgrade pynvim

zplug:
	git clone https://github.com/zplug/zplug.git ~/.zplug

stow:
	stow --restow --ignore ".DS_Store" --target="$(HOME)" --dir="$(DOTFILES)" files

fnm:
	curl -fsSL https://github.com/Schniz/fnm/raw/master/.ci/install.sh | bash

linuxrepo:
	sudo add-apt-repository ppa:lazygit-team/release
	sudo apt-get update

linuxzsh:
	sudo usermod -s $(which zsh) $(whoami)

debian:
	sudo apt-get -y install \
		ack \
		bat \
		cabextract \
		cmake \
		exuberant-ctags \
		fzf \
		gcc \
		gnupg \
		grep \
		highlight \
		htop \
		hub \
		kitty \
		lazygit \
		mono-devel \
		neofetch \
		neovim \
		ngrep \
		python-dev \
		python-pip \
		python3-dev \
		python3-pip \
		ripgrep \
		ruby2.5 \
		ruby2.5-dev \
		silversearcher-ag \
		tmux \
		vim \
		xclip \
		zsh
