#!/bin/bash

# ==== Install build dependencies such as python requirements ====
# TODO: Edit Here
# ================================================================


# Save the installed packages to a file. This is used to install the next container build
RO_CACHE_DIR=/home/$USER/.ro-container-cache
REQS_PATH=$RO_CACHE_DIR/requirements.txt
su $USER -c "source ~/.zshrc && pip freeze > $REQS_PATH"
chown root $RO_CACHE_DIR && chmod 755 $RO_CACHE_DIR
