####################
# functions
####################

# Create a new directory and enter it
function md() {
  mkdir -p $1
  cd $1
}

# find shorthand
function f() {
  find . -name "$1"
}

# function fzf-down() {
#   fzf --height 50% "$@" --border
# }

function fkill() {
  kill -9 $(ps ax | fzf | awk '{ print $1 }')
}

# A nice way to remove images
function rimage() {
  IMAGE=`docker images | fzf | awk '{print $1}'`

  docker rmi $IMAGE
}
