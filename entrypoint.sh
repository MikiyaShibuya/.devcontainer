#!/bin/bash

CACHE_DIR=/home/$USER/.container-cache
chmod 777 $CACHE_DIR

su $USER -c "mkdir -p $CACHE_DIR/nvim-tmp"
ln -sfn $CACHE_DIR/nvim-tmp /home/$USER/.config/nvim/tmp

su $USER -c "touch $CACHE_DIR/zsh-history"
ln -sfn $CACHE_DIR/zsh-history /home/$USER/.zsh-history

su $USER -c "mkdir -p $CACHE_DIR/p10k"
ln -sfn $CACHE_DIR/p10k /home/shibuya/.cache/p10k

su $USER -c "mkdir -p $CACHE_DIR/github-copilot"
ln -sfn $CACHE_DIR/github-copilot /home/shibuya/.config/github-copilot

/tmp/build_depend.sh

# Change SSH Port
sed -i "s/#Port 22/Port ${SSH_PORT}/" /etc/ssh/sshd_config \
  && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

service ssh start &> /dev/null

SSH_OK=$?

if [ $SSH_OK -eq 0 ]; then
  echo "========================================"
  echo " Dev container launched on port ${SSH_PORT}"
  echo "========================================"
else
  echo "Failed to start SSH Server"
  exit 1
fi

sleep infinity
