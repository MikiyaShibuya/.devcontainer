.devcontainer
==

## TL;DR
This makes a development container that fits my preferences.
- zsh & neovim
- [dotfiles](https://github.com/MikiyaShibuya/dotfiles)
- Python v3.12 (installed package will be included in next build)
- Node v10

## Install
Download this repo and build a docker image.  
```bash
cd <your working dir>
git clone git@github.com:MikiyaShibuya/.devcontainer.git
cd .devcontainer
vim install_depend.sh # *
U=`id -u` G=`id -g` docker compose build
```
**Points**
- Install what you need in development, e.g. python requirements.  
- Installed packages in install_depend.sh will be included in the docker image next time, so that container run overhead reduces :D
- The compose.yaml refers "USER" env value as the username in the container. So that the running user's name will be taken over by default.
- The SSH authorized keys will be taken over into the container.

## Launch
Just launch the docker image.  
```bash
docker compose up
```
The SSH PORT will appear.

## Get started with the development
```
ssh <username>@<host>:<port>
```
