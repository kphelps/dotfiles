#!/usr/bin/env bash

PACKAGES=(
    curl
    git
    gnome-terminal
    neovim
    vim
    wget
    zsh
)

DOTFILES_DIR=$(pwd)

sudo dnf install -y --best --allowerasing "${PACKAGES[@]}"

git submodule update --init --recursive

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sh <(curl https://j.mp/spf13-vim3 -L)

for vimfile in .vim*; do
    ln -sf "${DOTFILES_DIR}/${vimfile}" "${HOME}/${vimfile}"
done

mkdir -p ~/.config

for config in .config/*; do
    ln -sf "${DOTFILES_DIR}/${config}" "${HOME}/.config/"
done

nvim +BundleInstall! +qall

ln -sf "${DOTFILES_DIR}/background.jpg" ~/
ln -sf "${DOTFILES_DIR}/.zshrc" ~/
mkdir -p ~/.config/nvim
ln -sf "${HOME}/.vimrc" ~/.config/nvim/init.vim

mkdir -p ~/bin

pushd "${DOTFILES_DIR}/gnome-terminal-colors-solarized"
cp -r ../gnome-terminal-colors/colors/* colors
./install.sh -s gruvbox-dark
popd

mkdir -p ~/sandbox ~/dev

pushd "${DOTFILES_DIR}/i3"
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc
make
sudo make install
popd
