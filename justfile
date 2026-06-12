set dotenv-filename := "env"
set dotenv-required
set dotenv-load
set dotenv-override
set export

default: link-binaries

os := os()
arch := arch()
JD := justfile_directory()
GH := "https://github.com"

fuc_ver := "3.1.1"
fuc_cpz_fn := arch + "-unknown-" + os + "-gnu-cpz"
fuc_rmz_fn := arch + "-unknown-" + os + "-gnu-rmz"
fuc-link: \
(_getbin GH + "/SUPERCILEX/fuc/releases/download/" + fuc_ver + "/" + fuc_cpz_fn) \
(_getbin GH + "/SUPERCILEX/fuc/releases/download/" + fuc_ver + "/" + fuc_rmz_fn) \
(_link fuc_cpz_fn ".local/bin/cpz") \
(_link fuc_rmz_fn ".local/bin/rmz")

helix_ver := "1"
helix_fn := "helix-" + helix_ver + "-" + arch + "-" + os
helix-link: \
(_get GH + "/mjkpolo/helix/releases/download/" + helix_ver + "/" + helix_fn + ".tar.xz") \
(_link join(helix_fn, "hx") ".local/bin/hx") \
(_link join(helix_fn, "runtime") ".config/helix/runtime")

rg_ver := "15.1.0"
rg_fn := "ripgrep-" + rg_ver + "-" + arch + "-unknown-" + os + "-musl"
rg-link: \
(_get GH + "/BurntSushi/ripgrep/releases/download/" + rg_ver + "/" + rg_fn + ".tar.gz") \
(_link join(rg_fn, "rg") ".local/bin/rg")

fd_ver := "v10.4.2"
fd_fn := "fd-" + fd_ver + "-" + arch + "-unknown-" + os + "-musl"
fd-link: \
(_get GH + "/sharkdp/fd/releases/download/" + fd_ver + "/" + fd_fn + ".tar.gz") \
(_link join(fd_fn, "fd") ".local/bin/fd")

fzf_ver := "0.73.1"
fzf_arch := if arch == "x86_64" { "amd64" } else { arch }
fzf_fn := "fzf-" + fzf_ver + "-" + os + "_" + fzf_arch
fzf-link: \
(_get GH + "/junegunn/fzf/releases/download/v" + fzf_ver + "/" + fzf_fn + ".tar.gz") \
(_link "fzf" ".local/bin/fzf")

zellij_ver := "1"
zellij_fn := "zellij-no-web-" + arch + "-unknown-" + os + "-musl"
zellij-link: \
(_get GH + "/mjkpolo/zellij/releases/download/" + zellij_ver + "/" + zellij_fn + ".tar.gz") \
(_link "zellij" ".local/bin/zellij")

uv_ver := "0.11.21"
uv_fn := "uv-" + arch + "-unknown-" + os + "-musl"
uv-link: \
(_get "https://releases.astral.sh/github/uv/releases/download/" + uv_ver + "/" + uv_fn + ".tar.gz") \
(_mkdir ".cache/uv") \
(_link join(uv_fn, "uv") ".local/bin/uv") \
(_link join(uv_fn, "uvx") ".local/bin/uvx") \
(_link ".cache/uv" ".cache/uv") \
(_link ".venv" ".venv")
    uv venv --clear --python=3.12 .venv

[parallel]
link-dotfiles: \
(_link "env" ".env") \
(_link "bashrc" ".bashrc") \
(_link "dotzellij" ".zellij") \
(_link "config.github" "config.github") \
(_link "config.gitlab" "config.gitlab") \
(_link "gitconfig" ".gitconfig") \
(_link "dotzathura" ".config/zathura") \
(_link "dothelix" ".config/helix") \
(_secret_link "secretenv" ".secretenv")

[parallel]
link-binaries: link-dotfiles \
helix-link \
rg-link \
fd-link \
uv-link \
fzf-link \
zellij-link \
fuc-link

setup: \
(_mkdir "$HOME/.local/bin") \
(_mkdir "$HOME/.local/lib") \
(_mkdir "$HOME/.config")

_mkdir dir:
    mkdir -p {{dir}}

_get url: setup
    curl --proto '=https' --tlsv1.2 -sSfLO {{url}}
    tar -xf {{file_name(url)}}
    rm -f {{file_name(url)}}

_getbin url: setup
    curl --proto '=https' --tlsv1.2 -sSfLO {{url}}
    chmod +x {{file_name(url)}}

[script("bash")]
_link source dest: setup
    echo "Linking $JD/$source -> $HOME/$dest"
    [[ -e $HOME/$dest ]] && { unlink $HOME/$dest || rm -rf $HOME/$dest; }
    ln -sf $JD/$source $HOME/$dest

[script("bash")]
_secret_link source dest: setup
    if [[ -f $JD/$source ]]; then
        echo "Linking $JD/$source -> $HOME/$dest"
        [[ -e $HOME/$dest ]] && { unlink $HOME/$dest || rm -rf $HOME/$dest; }
        ln -sf $JD/$source $HOME/$dest
    fi
