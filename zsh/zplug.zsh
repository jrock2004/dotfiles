# only source zplug on initial load
if [ -z ${RELOAD} ]; then
	if ! [ type "zplug" > /dev/null 2>&1 ]; then
		source ~/.zplug/init.zsh
	fi

	zplug "zplug/zplug", hook-build:"zplug --self-manage"
	zplug "zsh-users/zsh-syntax-highlighting", defer:2
	zplug "zsh-users/zsh-autosuggestions"

	if ! zplug check --verbose; then
		printf "Install? [y/N]: "
		if read -q; then
			echo; zplug install
		fi
	fi

	zplug load
fi
