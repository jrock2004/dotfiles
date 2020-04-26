function rimage
  set image (docker images | fzf | awk '{print $1}')

  docker rmi $image
end
