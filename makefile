.ONESHELL:
SHELL := /bin/bash
UNAME := $(shell uname -s)

.PHONY: all
all: helix cargo-pkgs clangd fzf ltex-ls-plus tmux

.PHONY: ltex-ls-plus
ltex-ls-plus: link
	VERSION=18.4.0
	[[ $(UNAME) == Darwin ]] && FILE=mac-aarch64 || FILE=linux-x64
	curl -LO https://github.com/ltex-plus/ltex-ls-plus/releases/download/$$VERSION/ltex-ls-plus-$$VERSION-$$FILE.tar.gz
	tar xf ltex-ls-plus-$$VERSION-$$FILE.tar.gz
	rm ltex-ls-plus-$$VERSION-$$FILE.tar.gz
	cd ltex-ls-plus-$$VERSION
	ln -sf $$PWD/bin/ltex-ls-plus $$MYHOME/.local/bin/ltex-ls-plus

.PHONY: clangd
clangd: link
	VERSION=19.1.2
	[[ $(UNAME) == Darwin ]] && FILE=clangd-mac || FILE=clangd-linux
	curl -LO https://github.com/clangd/clangd/releases/download/$$VERSION/$$FILE-$$VERSION.zip
	unzip $$FILE-$$VERSION.zip && cp -R clangd_$$VERSION/bin/* $$MYHOME/.local/bin/ && cp -R clangd_$$VERSION/lib/* $$MYHOME/.local/lib/
	rm -rf clangd*

.PHONY: cargo
cargo:
	sh <(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y

.PHONY: cargo-pkgs
cargo-pkgs: cargo
	. "$$MYHOME/.cargo/env"
	cargo install fd-find --locked
	cargo install ripgrep --locked
	cargo install --git https://github.com/latex-lsp/texlab --locked --tag v5.21.0

.PHONY: helix
helix: cargo link
	. "$$MYHOME/.cargo/env"
	cd helix
	cargo install --path helix-term --locked
	ln -sf $$PWD/runtime ../dothelix/runtime

.PHONY: fzf
fzf: link
	cd fzf
	./install --all --no-zsh --no-fish

.PHONY: ncurses
ncurses: link
	curl -LO https://ftp.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz
	tar xzf ncurses-*.tar.gz
	rm ncurses-*.tar.gz
	cd ncurses-*/
	./configure --prefix=$$MYHOME/.local --with-shared --with-termlib --enable-pc-files --with-pkg-config-libdir=$$MYHOME/.local/lib/pkgconfig
	make -j20 && make install
	cd ..
	rm -rf ncurses-*/

.PHONY: libevent
libevent: link
	curl -LO https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
	tar xzf libevent-*.tar.gz
	rm libevent-*.tar.gz
	cd libevent-*/
	./configure --prefix=$$MYHOME/.local --enable-shared
	make -j20 && make install
	cd ..
	rm -rf libevent-*/

.PHONY: tmux
tmux: libevent ncurses
	curl -LO https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz
	tar xzf tmux-*.tar.gz
	rm tmux-*.tar.gz
	cd tmux-*/
	PKG_CONFIG_PATH=$$MYHOME/.local/lib/pkgconfig ./configure --prefix=$$MYHOME/.local
	make -j20 && make install
	cd ..
	rm -rf tmux-*/

.PHONY: link
link: setup
	[[ -d $$MYHOME/.local/bin ]] || mkdir -p $$MYHOME/.local/bin
	[[ -d $$MYHOME/.config ]] || mkdir -p $$MYHOME/.config
	unlink_or_remove() {
		INSTALL_LOC=$$1
		LOCAL_LOC=$$2
		[[ -z $$INSTALL_LOC ]] && { echo "Missing name" 2>&1 && exit 1; }
		[[ -z $$LOCAL_LOC ]] && LOCAL_LOC=$$INSTALL_LOC
		[[ -e $$MYHOME/$$INSTALL_LOC ]] && { unlink $$MYHOME/$$INSTALL_LOC || rm -rf $$MYHOME/$$INSTALL_LOC; }
		ln -sf $$PWD/$$LOCAL_LOC $$MYHOME/$$INSTALL_LOC
	}
	unlink_or_remove .bashrc bashrc
	unlink_or_remove .config/helix dothelix
	unlink_or_remove .tmux.conf tmux.conf
	unlink_or_remove .config/alacritty dotalacritty
	unlink_or_remove config.github
	unlink_or_remove config.gitlab
	unlink_or_remove .gitconfig gitconfig

.PHONY: setup
setup:
	git submodule update --init --recursive
