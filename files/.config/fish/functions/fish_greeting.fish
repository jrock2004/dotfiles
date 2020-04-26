function fish_greeting
  if command -v neofetch
    neofetch
  else
    echo "You need to install neofetch"
  end
end
