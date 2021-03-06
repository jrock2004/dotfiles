FROM ubuntu:20.04
LABEL author="John Costanzo"

COPY docker-entrypoint.sh /entrypoint.sh

RUN apt-get update && apt-get install -y curl wget git sudo ruby make build-essential file language-pack-en && \
  rm -rf /var/lib/apt/lists/* && \
  useradd -ms /bin/bash user && \
  echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user

USER user:user

WORKDIR /home/user

RUN touch .bash_profile && \
  git clone https://github.com/jrock2004/dotfiles.git .dotfiles

WORKDIR /home/user/.dotfiles

ENTRYPOINT [ "/entrypoint.sh" ]
