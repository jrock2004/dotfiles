DOTFILES=${HOME}/.dotfiles

# Arguments to pass to make
apple: brew fzf stow neovim zplug

brew:
	brew bundle

fzf:
	/usr/local/opt/fzf/install --all --no-bash --no-fish

neovim:
	python3 -m pip install --upgrade pynvim
	nvim +PlugInstall +qall

zplug:
	git clone https://github.com/zplug/zplug.git ~/.zplug

stow:
	stow --restow --ignore ".DS_Store" --target="$(HOME)" --dir="$(DOTFILES)" files