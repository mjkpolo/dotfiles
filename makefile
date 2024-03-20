.ONESHELL:
SHELL := /bin/bash
UNAME := $(shell uname -s)

.PHONY: all
all: helix clangd

.PHONY: clangd
clangd: link
	[[ $(UNAME) == Darwin ]] && FILE=clangd-mac || FILE=clangd-linux
	curl -LO https://github.com/clangd/clangd/releases/download/17.0.3/$$FILE-17.0.3.zip
	unzip $$FILE-17.0.3.zip && mv clangd_17.0.3/bin/* $$HOME/.local/bin/ && mv clangd_17.0.3/lib/* $$HOME/.local/lib
	rm -rf clangd*

.PHONY: cargo
cargo:
	sh <(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y # first install rust

.PHONY: helix
helix: cargo link
	git clone https://github.com/helix-editor/helix
	cd helix
	cargo install --path helix-term --locked
	ln -Ts $$PWD/runtime ~/.config/helix/runtime

.PHONY: link
link:
	[[ -d $$HOME/.local/bin ]] || mkdir -p $$HOME/.local/bin
	[[ -d $$HOME/.config ]] || mkdir -p $$HOME/.config

	[[ $(UNAME) == Darwin ]] && BASHLOC=bash_profile || BASHLOC=bashrc
	[[ -e $$HOME/.$$BASHLOC ]] && (unlink $$HOME/.$$BASHLOC || rm -rf $$HOME/.$$BASHLOC)
	ln -sf $$PWD/bashrc $$HOME/.$$BASHLOC

	[[ -e $$HOME/.config/helix ]] && (unlink $$HOME/.config/helix || rm -rf $$HOME/.config/helix)
	ln -sf $$PWD/dothelix $$HOME/.config/helix

	[[ -e $$HOME/.tmux.conf ]] && (unlink $$HOME/.tmux.conf || rm -rf $$HOME/.tmux.conf)
	ln -sf $$PWD/tmux.conf $$HOME/.tmux.conf

	[[ -e $$HOME/.config/kitty ]] && (unlink $$HOME/.config/kitty || rm -rf $$HOME/.config/kitty)
	ln -sf $$PWD/dotkitty $$HOME/.config/kitty

	[[ -e $$HOME/config.github ]] && (unlink $$HOME/config.github || rm -rf $$HOME/config.github)
	ln -sf $$PWD/config.github $$HOME/config.github

	[[ -e $$HOME/config.gitlab ]] && (unlink $$HOME/config.gitlab || rm -rf $$HOME/config.gitlab)
	ln -sf $$PWD/config.gitlab $$HOME/config.gitlab

	[[ -e $$HOME/.gitconfig ]] && (unlink $$HOME/.gitconfig || rm -rf $$HOME/.gitconfig)
	ln -sf $$PWD/gitconfig $$HOME/.gitconfig
