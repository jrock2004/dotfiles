####################
# functions
####################

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

function fzf-down() {
  fzf --height 50% "$@" --border
}

# Cleaner way to add things to the path
function pathmunge () {
  if ! echo "$PATH" | /usr/bin/grep -Eq "(^|:)$1($|:)" ; then
    if [ "$2" = "after" ] ; then
      PATH="$PATH:$1"
    else
      PATH="$1:$PATH"
    fi
  fi
}

function fkill() {
  kill -9 $(ps ax | fzf | awk '{ print $1 }')
}

# A nice way to remove images
function rimage() {
  IMAGE=`docker images | fzf | awk '{print $1}'`

  docker rmi $IMAGE
}
