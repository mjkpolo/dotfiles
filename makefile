.ONESHELL:
SHELL := /bin/bash
UNAME := $(shell uname -s)

.PHONY: all
all: helix clangd tmux

.PHONY: clangd
clangd: link
	[[ $(UNAME) == Darwin ]] && FILE=clangd-mac || FILE=clangd-linux
	curl -LO https://github.com/clangd/clangd/releases/download/17.0.3/$$FILE-17.0.3.zip
	unzip $$FILE-17.0.3.zip && mv clangd_17.0.3/bin/* $$HOME/.local/bin/ && mv clangd_17.0.3/lib/* $$HOME/.local/lib
	rm -rf clangd*

.PHONY: cargo
cargo:
	sh <(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y

.PHONY: tmux
tmux: link
	git clone https://github.com/tmux/tmux.git
	cd tmux
	sh autogen.sh
	./configure --prefix=$$HOME/.local && make install -j

.PHONY: helix
helix: cargo link
	git clone https://github.com/helix-editor/helix
	cd helix
	. "$$HOME/.cargo/env"
	cargo install --path helix-term --locked
	ln -sf $$PWD/runtime ../dothelix/runtime

.PHONY: link
link:
	[[ -d $$HOME/.local/bin ]] || mkdir -p $$HOME/.local/bin
	[[ -d $$HOME/.config ]] || mkdir -p $$HOME/.config
	[[ $(UNAME) == Darwin ]] && BASHLOC=bash_profile || BASHLOC=bashrc
	unlink_or_remove() {
		INSTALL_LOC=$$1
		LOCAL_LOC=$$2
		[[ -z $$INSTALL_LOC ]] && { echo "Missing name" 2>&1 && exit 1; }
		[[ -z $$LOCAL_LOC ]] && LOCAL_LOC=$$INSTALL_LOC
		[[ -e $$HOME/$$INSTALL_LOC ]] && { unlink $$HOME/$$INSTALL_LOC || rm -rf $$HOME/$$INSTALL_LOC; }
		ln -sf $$PWD/$$LOCAL_LOC $$HOME/$$INSTALL_LOC
	}
	unlink_or_remove .$$BASHLOC bashrc
	unlink_or_remove .config/helix dothelix
	unlink_or_remove .tmux.conf tmux.conf
	unlink_or_remove .config/kitty dotkitty
	unlink_or_remove config.github
	unlink_or_remove config.gitlab
	unlink_or_remove .gitconfig gitconfig
