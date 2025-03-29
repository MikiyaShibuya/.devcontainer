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

/tmp/install_depend.sh

# Save the installed python packages to a file.
# This will be used in the next container build
RO_CACHE_DIR=/home/$USER/.ro-container-cache
REQS_PATH=$RO_CACHE_DIR/requirements.txt
su $USER -c "source ~/.zshrc && pip freeze > $REQS_PATH"
chown root $RO_CACHE_DIR && chmod 755 $RO_CACHE_DIR


# Change SSH Port, allow root login
sed -i "s/#Port 22/Port ${SSH_PORT}/" /etc/ssh/sshd_config \
  && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Apply SSH authorized keys from host PC
su $USER -c "cp /tmp/.host-ssh/authorized_keys /home/$USER/.ssh/authorized_keys"

# Start SSH server
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
