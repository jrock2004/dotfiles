DOTFILES=${HOME}/.dotfiles

# Arguments to pass to make
apple: brew stow zolta fzf neovim zplug
linux: linuxrepo debian stow linuxfzf zolta neovim zplug
pie: linuxpie stow zolta neovim zplug

brew:
	brew bundle

fzf:
	/usr/local/opt/fzf/install --all --no-bash --no-fish

linuxfzf:
	sudo mkdir /usr/local/opt
	sudo chown -R $(whoami) /usr/local/opt
	sudo chmod -R 775 /usr/local/opt
	git clone --depth 1 https://github.com/junegunn/fzf.git /usr/local/opt/fzf
	/usr/local/opt/fzf/install

neovim:
	python3 -m pip install --upgrade pynvim

zplug:
	git clone https://github.com/zplug/zplug.git ~/.zplug

stow:
	stow --restow --ignore ".DS_Store" --target="$(HOME)" --dir="$(DOTFILES)" files

linuxrepo:
	sudo add-apt-repository ppa:lazygit-team/release
	sudo apt-get update

linuxzsh:
	chsh -s $(which zsh) $(whoami)

debian:
	sudo apt-get -y install \
		ack \
		bat \
		cabextract \
		cmake \
		exuberant-ctags \
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

linuxpie:
	sudo apt-get -y install \
		ack \
		cabextract \
		cmake \
		exuberant-ctags \
		gcc \
		gnupg \
		grep \
		highlight \
		htop \
		hub \
		kitty \
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

nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

zolta:
	curl https://get.volta.sh | bash -s -- --skip-setup
