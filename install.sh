#!/usr/bin/env bash

PACKAGES=(
    automake
    cairo-devel
    curl
    git
    gnome-terminal
    libev-devel
    libxkbcommon-devel
    libxkbcommon-x11-devel
    neovim
    pango-devel
    pcre-devel
    startup-notification-devel
    the_silver_searcher
    util-linux-user
    xcb-*-devel
    wget
    yajl-devel
    zsh
)

DOTFILES_DIR=$(pwd)

sudo dnf update
sudo dnf install -y vim
sudo dnf install -y --best --allowerasing "${PACKAGES[@]}"

git submodule update --init --recursive

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sh <(curl https://raw.githubusercontent.com/kphelps/spf13-vim/3.0/bootstrap.sh -L)

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
./install.sh -s gruvbox-dark -p Default --skip-dircolors
popd

mkdir -p ~/sandbox ~/dev

pushd "${DOTFILES_DIR}/i3"
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install
popd

pushd "${DOTFILES_DIR}/i3blocks"
make
sudo make install
popd

pushd "${DOTFILES_DIR}/rofi"
autoreconf -i
rm -rf build/
mkdir build && cd build
../configure
make
sudo make install
popd

mkdir "${HOME}/.fonts"
pushd "${HOME}/.fonts"
wget https://github.com/chrissimpkins/Hack/releases/download/v2.020/Hack-v2_020-ttf.zip
unzip Hack-v2_020-ttf.zip
rm Hack-v2_020-ttf.zip
popd
fc-cache -f
