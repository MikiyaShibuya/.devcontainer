#!/bin/bash

# ==== Install build dependencies such as python requirements ====
# TODO: Edit Here
# ================================================================


# Save the installed packages to a file. This is used to install the next container build
REQS_PATH=/home/$USER/.local/share/container-cache/python3/requirements.txt
su $USER -c "source ~/.zshrc && pip freeze > $REQS_PATH"
