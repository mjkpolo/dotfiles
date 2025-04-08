.ONESHELL:
SHELL := /bin/bash
UNAME := $(shell uname -s)

.PHONY: all
all: helix cargo-pkgs clangd fzf ltex-ls-plus tmux uv-venv

.PHONY: ltex-ls-plus
ltex-ls-plus: link
	VERSION=18.5.0
	source bashrc
	[[ $(UNAME) == Darwin ]] && FILE=mac-aarch64 || FILE=linux-x64
	curl -LO https://github.com/ltex-plus/ltex-ls-plus/releases/download/$$VERSION/ltex-ls-plus-$$VERSION-$$FILE.tar.gz
	tar xf ltex-ls-plus-$$VERSION-$$FILE.tar.gz
	rm ltex-ls-plus-$$VERSION-$$FILE.tar.gz
	cd ltex-ls-plus-$$VERSION
	ln -sf $$PWD/bin/ltex-ls-plus $$MYHOME/.local/bin/ltex-ls-plus

.PHONY: clangd
clangd: link
	VERSION=19.1.2
	source bashrc
	[[ $(UNAME) == Darwin ]] && FILE=clangd-mac || FILE=clangd-linux
	curl -LO https://github.com/clangd/clangd/releases/download/$$VERSION/$$FILE-$$VERSION.zip
	unzip $$FILE-$$VERSION.zip && cp -R clangd_$$VERSION/bin/* $$MYHOME/.local/bin/ && cp -R clangd_$$VERSION/lib/* $$MYHOME/.local/lib/
	rm -rf clangd*

.PHONY: cargo
cargo:
	source bashrc
	[[ -d $$CARGO_HOME ]] || sh <(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y

.PHONY: uv-venv
uv-venv: cargo-pkgs
	source bashrc
	[[ -d $$MYHOME/.venv ]] || uv venv $$MYHOME/.venv

.PHONY: cargo-pkgs
cargo-pkgs: cargo
	source bashrc
	. $$CARGO_HOME/env
	cargo install fd-find --locked
	cargo install ripgrep --locked
	cargo install --git https://github.com/latex-lsp/texlab --locked --tag v5.21.0
	cargo install --git https://github.com/astral-sh/uv uv --locked

.PHONY: helix
helix: cargo link
	source bashrc
	. $$CARGO_HOME/env
	cd helix
	cargo install --path helix-term --locked
	ln -sf $$PWD/runtime ../dothelix/runtime

.PHONY: fzf
fzf: link
	cd fzf
	./install --all --no-zsh --no-fish

.PHONY: tmux
tmux: ncurses libevent bison
	VERSION=3.5a
	source bashrc
	curl -LO https://github.com/tmux/tmux/releases/download/$$VERSION/tmux-$$VERSION.tar.gz
	tar xzf tmux-$$VERSION.tar.gz
	rm tmux-$$VERSION.tar.gz
	cd tmux-$$VERSION
	PKG_CONFIG_PATH=$$MYHOME/.local/lib/pkgconfig ./configure --prefix=$$MYHOME/.local
	make -j20 && make install
	cd ..
	rm -rf tmux-$$VERSION

.PHONY: bison
bison: link
	VERSION=3.8
	source bashrc
	curl -LO https://ftp.gnu.org/gnu/bison/bison-$$VERSION.tar.gz
	tar xzf bison-$$VERSION.tar.gz
	rm bison-$$VERSION.tar.gz
	cd bison-$$VERSION
	./configure --prefix=$$MYHOME/.local
	make -j20 && make install
	cd ..
	rm -rf bison-$$VERSION

.PHONY: ncurses
ncurses: link
	VERSION=6.5
	source bashrc
	curl -LO https://ftp.gnu.org/gnu/ncurses/ncurses-$$VERSION.tar.gz
	tar xzf ncurses-$$VERSION.tar.gz
	rm ncurses-$$VERSION.tar.gz
	cd ncurses-$$VERSION
	./configure --prefix=$$MYHOME/.local --with-shared --with-termlib --enable-pc-files --with-pkg-config-libdir=$$MYHOME/.local/lib/pkgconfig
	make -j20 && make install
	cd ..
	rm -rf ncurses-$$VERSION

.PHONY: libevent
libevent: link openssl
	VERSION=2.1.12-stable
	source bashrc
	curl -LO https://github.com/libevent/libevent/releases/download/release-$$VERSION/libevent-$$VERSION.tar.gz
	tar xzf libevent-$$VERSION.tar.gz
	rm libevent-$$VERSION.tar.gz
	cd libevent-$$VERSION
	PKG_CONFIG_PATH=$$MYHOME/.local/lib64/pkgconfig ./configure --prefix=$$MYHOME/.local --enable-shared
	make -j20 && make install
	cd ..
	rm -rf libevent-$$VERSION

.PHONY: openssl
openssl: link
	VERSION=3.4.1
	source bashrc
	curl -LO https://github.com/openssl/openssl/releases/download/openssl-$$VERSION/openssl-$$VERSION.tar.gz
	tar xzf openssl-$$VERSION.tar.gz
	rm openssl-$$VERSION.tar.gz
	cd openssl-$$VERSION
	./Configure --prefix=$$MYHOME/.local
	make -j20 && make install
	cd ..
	rm -rf openssl-$$VERSION

.PHONY: link
link: setup
	source bashrc
	[[ -d $$MYHOME/.local/bin ]] || mkdir -p $$MYHOME/.local/bin
	[[ -d $$MYHOME/.local/lib ]] || mkdir -p $$MYHOME/.local/lib
	[[ -d $$HOME/.config ]] || mkdir -p $$HOME/.config
	unlink_or_remove() {
		LOCAL_NAME=$$1
		INSTALL_NAME=$$2
		[[ -e $$HOME/$$INSTALL_NAME ]] && { unlink $$HOME/$$INSTALL_NAME || rm -rf $$HOME/$$INSTALL_NAME; }
		ln -sf $$PWD/$$LOCAL_NAME $$HOME/$$INSTALL_NAME
	}
	unlink_or_remove bashrc .bashrc
	unlink_or_remove dothelix .config/helix
	unlink_or_remove tmux.conf .tmux.conf
	unlink_or_remove dotalacritty .config/alacritty
	unlink_or_remove config.github config.github
	unlink_or_remove config.gitlab config.gitlab
	unlink_or_remove gitconfig .gitconfig

.PHONY: setup
setup:
	git submodule update --init --recursive
