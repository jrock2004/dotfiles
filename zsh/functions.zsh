####################
# functions
####################

# print available colors and their numbers
function colours() {
    for i in {0..255}; do
        printf "\x1b[38;5;${i}m colour${i}"
        if (( $i % 5 == 0 )); then
            printf "\n"
        else
            printf "\t"
        fi
    done
}

# Create a new directory and enter it
function md() {
    mkdir -p "$@" && cd "$@"
}

function hist() {
    history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

# find shorthand
function f() {
    find . -name "$1"
}

# get gzipped size
function gz() {
    echo "orig size    (bytes): "
    cat "$1" | wc -c
    echo "gzipped size (bytes): "
    gzip -c "$1" | wc -c
}

# All the dig info
function digga() {
    dig +nocmd "$1" any +multiline +answer
}

# Extract archives - use: extract <file>
# Credits to http://dotfiles.org/~pseup/.bashrc
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz) tar xzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) rar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xf $1 ;;
            *.tbz2) tar xjf $1 ;;
            *.tgz) tar xzf $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function is_in_git_repo() {
	git rev-parse HEAD > /dev/null 2>&1
}

function fzf-down() {
	fzf --height 50% "$@" --border
}

function gf() {
	is_in_git_repo || return
	git -c color.status=always status --short |
	fzf-down -m --ansi --nth 2..,.. \
		--preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
	cut -c4- | sed 's/.* -> //'
}

function gb() {
	is_in_git_repo || return
	git branch -a --color=always | grep -v '/HEAD\s' | sort |
	fzf-down --ansi --multi --tac --preview-window right:70% \
		--preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' |
	sed 's/^..//' | cut -d' ' -f1 |
	sed 's#^remotes/##'
}

function gt() {
	is_in_git_repo || return
	git tag --sort -version:refname |
	fzf-down --multi --preview-window right:70% \
		--preview 'git show --color=always {} | head -200'
}

function gh() {
	is_in_git_repo || return
	git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
	fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
		--header 'Press CTRL-S to toggle sort' \
		--preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -200' |
	grep -o "[a-f0-9]\{7,\}"
}

function gr() {
	is_in_git_repo || return
	git remote -v | awk '{print $1 "\t" $2}' | uniq |
	fzf-down --tac \
		--preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
	cut -d$'\t' -f1
}
