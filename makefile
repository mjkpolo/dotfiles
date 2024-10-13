.ONESHELL:
SHELL := /bin/bash
UNAME := $(shell uname -s)

.PHONY: all
all: neovim cargo-pkgs clangd fzf

.PHONY: clangd
clangd: link
	[[ $(UNAME) == Darwin ]] && FILE=clangd-mac || FILE=clangd-linux
	VERSION=19.1.0
	curl -LO https://github.com/clangd/clangd/releases/download/$$VERSION/$$FILE-$$VERSION.zip
	unzip $$FILE-$$VERSION.zip && cp -R clangd_$$VERSION/bin/* $$HOME/.local/bin/ && cp -R clangd_$$VERSION/lib/* $$HOME/.local/lib/
	rm -rf clangd*

.PHONY: cargo
cargo:
	sh <(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y

.PHONY: cargo-pkgs
cargo-pkgs: cargo
	. "$$HOME/.cargo/env"
	cargo install fd-find ripgrep zellij

.PHONY: neovim
neovim: link
	VERSION=v0.10.2
	if [[ $(UNAME) == Darwin ]]
	then
		FILE=nvim-macos-arm64
		curl -LO https://github.com/neovim/neovim/releases/download/$$VERSION/$$FILE.tar.gz
		xattr -c ./$$FILE.tar.gz
	else
		FILE=nvim-linux64
		curl -LO https://github.com/neovim/neovim/releases/download/$$VERSION/$$FILE.tar.gz
	fi
	tar -xzf $$FILE.tar.gz --strip-components=1 -C $$HOME/.local
	rm $$FILE.tar.gz
	rm -rf $$FILE

.PHONY: fzf
fzf: link
	cd fzf
	./install --all --no-zsh --no-fish

.PHONY: link
link: setup
	[[ -d $$HOME/.local/bin ]] || mkdir -p $$HOME/.local/bin
	[[ -d $$HOME/.config ]] || mkdir -p $$HOME/.config
	unlink_or_remove() {
		INSTALL_LOC=$$1
		LOCAL_LOC=$$2
		[[ -z $$INSTALL_LOC ]] && { echo "Missing name" 2>&1 && exit 1; }
		[[ -z $$LOCAL_LOC ]] && LOCAL_LOC=$$INSTALL_LOC
		[[ -e $$HOME/$$INSTALL_LOC ]] && { unlink $$HOME/$$INSTALL_LOC || rm -rf $$HOME/$$INSTALL_LOC; }
		ln -sf $$PWD/$$LOCAL_LOC $$HOME/$$INSTALL_LOC
	}
	unlink_or_remove .bashrc bashrc
	unlink_or_remove .config/helix dothelix
	unlink_or_remove .config/zellij dotzellij
	unlink_or_remove .config/alacritty dotalacritty
	unlink_or_remove .config/nvim kickstart.nvim
	unlink_or_remove config.github
	unlink_or_remove config.gitlab
	unlink_or_remove .gitconfig gitconfig

.PHONY: setup
setup:
	git submodule update --init --recursive
