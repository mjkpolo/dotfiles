set dotenv-filename := "env"
set dotenv-required
set dotenv-load
set dotenv-override
set export

default: link

os := os()
arch := arch()
JD := justfile_directory()


fuc_ver := "3.1.1"
fuc_cpz_fn := arch + "-unknown-" + os + "-gnu-cpz"
fuc_rmz_fn := arch + "-unknown-" + os + "-gnu-rmz"

fuc-link: \
fuc-download \
(_link fuc_cpz_fn ".local/bin/cpz") \
(_link fuc_rmz_fn ".local/bin/rmz") \

fuc-download: setup
    curl --proto '=https' --tlsv1.2 -sSfLO https://github.com/SUPERCILEX/fuc/releases/download/{{fuc_ver}}/{{fuc_cpz_fn}}
    curl --proto '=https' --tlsv1.2 -sSfLO https://github.com/SUPERCILEX/fuc/releases/download/{{fuc_ver}}/{{fuc_rmz_fn}}
    chmod +x {{fuc_cpz_fn}}
    chmod +x {{fuc_rmz_fn}}


helix_ver := "1"
helix_fn := "helix-" + helix_ver + "-" + arch + "-" + os

helix-link: \
helix-download \
(_link join(helix_fn, "hx") ".local/bin/hx") \
(_link join(helix_fn, "runtime") ".config/helix/runtime") \

helix-download: setup
    curl --proto '=https' --tlsv1.2 -sSfLO https://github.com/mjkpolo/helix/releases/download/{{helix_ver}}/{{helix_fn}}.tar.xz
    tar -xf {{helix_fn}}.tar.xz
    rm -f {{helix_fn}}.tar.xz


rg_ver := "15.1.0"
rg_fn := "ripgrep-" + rg_ver + "-" + arch + "-unknown-" + os + "-musl"

rg-link: \
rg-download \
(_link join(rg_fn, "rg") ".local/bin/rg") \

rg-download: setup
    curl --proto '=https' --tlsv1.2 -sSfLO https://github.com/BurntSushi/ripgrep/releases/download/{{rg_ver}}/{{rg_fn}}.tar.gz
    tar -xf {{rg_fn}}.tar.gz
    rm -f {{rg_fn}}.tar.gz


fd_ver := "v10.4.2"
fd_fn := "fd-" + fd_ver + "-" + arch + "-unknown-" + os + "-musl"

fd-link: \
fd-download \
(_link join(fd_fn, "fd") ".local/bin/fd") \

fd-download: setup
    curl --proto '=https' --tlsv1.2 -sSfLO https://github.com/sharkdp/fd/releases/download/{{fd_ver}}/{{fd_fn}}.tar.gz
    tar -xf {{fd_fn}}.tar.gz
    rm -f {{fd_fn}}.tar.gz


uv_ver := "0.11.21"
uv_fn := "uv-" + arch + "-unknown-" + os + "-musl"

uv-link: \
uv-download \
(_link join(uv_fn, "uv") ".local/bin/uv") \
(_link join(uv_fn, "uvx") ".local/bin/uvx") \
(_link ".cache/uv" ".cache/uv") \
(_link ".venv" ".venv")
    uv venv --clear --python=3.12 .venv

uv-download: setup
    curl --proto '=https' --tlsv1.2 -sSfLO https://releases.astral.sh/github/uv/releases/download/{{uv_ver}}/{{uv_fn}}.tar.gz
    tar -xf {{uv_fn}}.tar.gz
    rm -f {{uv_fn}}.tar.gz
    mkdir -p .cache/uv


fzf_ver := "0.73.1"
fzf_arch := if arch == "x86_64" { "amd64" } else { arch }
fzf_fn := "fzf-" + fzf_ver + "-" + os + "_" + fzf_arch

fzf-link: \
fzf-download \
(_link "fzf" ".local/bin/fzf")

fzf-download: setup
    curl --proto '=https' --tlsv1.2 -sSfLO https://github.com/junegunn/fzf/releases/download/v{{fzf_ver}}/{{fzf_fn}}.tar.gz
    tar -xf {{fzf_fn}}.tar.gz
    rm -f {{fzf_fn}}.tar.gz


zellij_ver := "1"
zellij_fn := "zellij-no-web-" + arch + "-unknown-" + os + "-musl"

zellij-link: \
zellij-download \
(_link "zellij" ".local/bin/zellij")

zellij-download: setup
    curl --proto '=https' --tlsv1.2 -sSfLO https://github.com/mjkpolo/zellij/releases/download/{{zellij_ver}}/{{zellij_fn}}.tar.gz
    tar -xf {{zellij_fn}}.tar.gz
    rm -f {{zellij_fn}}.tar.gz

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
(_secret_link "secretenv" ".secretenv") \

[parallel]
link-binaries: link-dotfiles \
helix-link \
rg-link \
fd-link \
uv-link \
fzf-link \
zellij-link \
fuc-link

link: link-binaries

setup:
    mkdir -p $HOME/.local/bin
    mkdir -p $HOME/.local/lib
    mkdir -p $HOME/.config


[script("bash")]
_link source dest:
    echo "Linking $JD/$source -> $HOME/$dest"
    [[ -e $HOME/$dest ]] && { unlink $HOME/$dest || rm -rf $HOME/$dest; }
    ln -sf $JD/$source $HOME/$dest

[script("bash")]
_secret_link source dest:
    if [[ -f source ]]; then
        echo "Linking $JD/$source -> $HOME/$dest"
        [[ -e $HOME/$dest ]] && { unlink $HOME/$dest || rm -rf $HOME/$dest; }
        ln -sf $JD/$source $HOME/$dest
    fi
