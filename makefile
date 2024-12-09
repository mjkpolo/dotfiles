.ONESHELL:
SHELL := /bin/bash
UNAME := $(shell uname -s)

.PHONY: all
all: helix cargo-pkgs clangd fzf

.PHONY: clangd
clangd: link
	VERSION=19.1.0
	[[ $(UNAME) == Darwin ]] && FILE=clangd-mac || FILE=clangd-linux
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

.PHONY: helix
helix: cargo link
	. "$$HOME/.cargo/env"
	cd helix
	cargo install --path helix-term --locked
	ln -sf $$PWD/runtime ../dothelix/runtime

.PHONY: wezterm
wezterm: link
	VERSION=20240203-110809-5046fc22
	if [[ $(UNAME) == Darwin ]]
	then
		FILE=WezTerm-macos-$$VERSION
		EXT=zip
	else
		FILE=wezterm-$$VERSION.Ubuntu20.04
		EXT=tar.xz
	fi
	wget https://github.com/wez/wezterm/releases/download/$$VERSION/$$FILE.$$EXT
	[[ $$EXT == zip ]] && unzip $$FILE.$$EXT || tar xf $$FILE.$$EXT
	rm $$FILE.$$EXT
	if [[ $(UNAME) == Darwin ]]
	then
		mv $$FILE/Wezterm.app $$HOME/Applications/
		rmdir $$FILE
	else
		ln -sf $$PWD/wezterm/usr/bin/* $$HOME/.local/bin/
		echo ". $$PWD/wezterm/etc/profile.d/wezterm.sh" >> $$HOME/.profile
	fi

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
	unlink_or_remove .config/wezterm dotwezterm
	unlink_or_remove config.github
	unlink_or_remove config.gitlab
	unlink_or_remove .gitconfig gitconfig

.PHONY: setup
setup:
	git submodule update --init --recursive
