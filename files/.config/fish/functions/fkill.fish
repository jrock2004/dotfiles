function fkill
  kill -9 (ps ax | fzf | awk '{ print $1 }')
end
