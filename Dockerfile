FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    sudo unzip curl git \
    zsh openssh-server locales-all lsb-release \
    ca-certificates

# User setting
ARG GID
ARG UID
ARG USER

RUN if [ "$(getent passwd $UID)" != "" ]; then \
    userdel -r "$(getent passwd $UID | awk -F: '{print $1}')"; \
  fi \
  && if [ -z "$(getent group $GID)" ]; then \
    groupadd -g $GID $USER; \
  fi \
  && if [ -z "$(getent passwd $USER)" ]; then \
    useradd -u $UID -g $GID -s /bin/zsh -m $USER \
    && echo $USER:0000 | chpasswd \
    && adduser $USER sudo; \
  fi

# Install custom env
RUN HOMEDIR=$(eval echo ~$USER) \
  && WORKDIR=$HOMEDIR/.local/share/dotfiles \
  && su $USER -c  \
    "mkdir -p $WORKDIR && cd $WORKDIR \
     && git init &> /dev/null && git remote add origin https://github.com/MikiyaShibuya/dotfiles.git \
     && git fetch --depth 1 origin f41996def7298f7cc66efcca2ab03de101dea004 \
     && git checkout FETCH_HEAD" \
  && cd $WORKDIR && USER=$USER ./install.sh

COPY .cache/python3 /home/$USER/.local/share/container-cache/python3

RUN VENV_DIR=/home/$USER/.local/.venv \
  && su $USER -c \
    "python3 -m venv --system-site-packages --clear \
        --prompt 'dev-container' \
        --upgrade-deps $VENV_DIR" \
  && echo "source $VENV_DIR/bin/activate" >> /home/$USER/.zshrc

RUN REQS_PATH=/home/$USER/.local/share/container-cache/python3/requirements.txt \
  && if [ -f "$REQS_PATH" ]; then su $USER -c \
    "source $VENV_DIR/bin/activate \
      && pip install --upgrade pip \
      && pip install -r $REQS_PATH" \
     ;fi


ENV LANG=en_US.UTF-8
ENV USER=$USER

COPY build_depend.sh /tmp/build_depend.sh
COPY entrypoint.sh /tmp/entrypoint.sh
CMD ["/tmp/entrypoint.sh"]
