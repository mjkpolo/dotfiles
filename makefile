.ONESHELL:
SHELL := /bin/bash
UNAME := $(shell uname -s)

.PHONY: all
all: link helix

.PHONY: clangd
clangd: link
	[[ $(UNAME) == Darwin ]] && FILE=clangd-mac || FILE=clangd-linux
	curl -LO https://github.com/clangd/clangd/releases/download/17.0.3/$$FILE-17.0.3.zip
	unzip $$FILE-17.0.3.zip && mv clangd_17.0.3/bin/* $$HOME/.local/bin/ && mv clangd_17.0.3/lib/* $$HOME/.local/lib
	rm -rf clangd*

.PHONY: helix
helix: link
	[[ $(UNAME) == Darwin ]] && ARCH=aarch64-macos || ARCH=x86_64-linux
	FILE=helix-23.10-$$ARCH.tar.xz
	curl -LO https://github.com/helix-editor/helix/releases/download/23.10/$$FILE
	[[ $(UNAME) == Darwin ]] && xattr -c ./$$FILE
	tar xzvf $$FILE -C $$HOME/.local/bin --strip-components=1
	rm $$FILE

.PHONY: link
link:
	[[ -d $$HOME/.local/bin ]] || mkdir -p $$HOME/.local/bin
	[[ -d $$HOME/.config ]] || mkdir -p $$HOME/.config

	[[ $(UNAME) == Darwin ]] && BASHLOC=bash_profile || BASHLOC=bashrc
	[[ -e $$HOME/.$$BASHLOC ]] && (unlink $$HOME/.$$BASHLOC || rm -rf $$HOME/.$$BASHLOC)
	ln -sf $$PWD/bashrc $$HOME/.$$BASHLOC

	[[ -e $$HOME/.config/helix ]] && (unlink $$HOME/.config/helix || rm -rf $$HOME/.config/helix)
	ln -sf $$PWD/helix $$HOME/.config/helix

	[[ -e $$HOME/.tmux.conf ]] && (unlink $$HOME/.tmux.conf || rm -rf $$HOME/.tmux.conf)
	ln -sf $$PWD/tmux.conf $$HOME/.tmux.conf

	[[ -e $$HOME/.config/kitty ]] && (unlink $$HOME/.config/kitty || rm -rf $$HOME/.config/kitty)
	ln -sf $$PWD/kitty $$HOME/.config/kitty

	[[ -e $$HOME/config.github ]] && (unlink $$HOME/config.github || rm -rf $$HOME/config.github)
	ln -sf $$PWD/config.github $$HOME/config.github

	[[ -e $$HOME/config.gitlab ]] && (unlink $$HOME/config.gitlab || rm -rf $$HOME/config.gitlab)
	ln -sf $$PWD/config.gitlab $$HOME/config.gitlab

	[[ -e $$HOME/.gitconfig ]] && (unlink $$HOME/.gitconfig || rm -rf $$HOME/.gitconfig)
	ln -sf $$PWD/gitconfig $$HOME/.gitconfig
