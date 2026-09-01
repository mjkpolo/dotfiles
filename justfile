set dotenv-filename := "env"
set dotenv-required
set dotenv-load
set dotenv-override
set export

[parallel]
default: \
link-dotfiles \
link-binaries

[parallel]
extra: \
link-dotfiles \
link-binaries \
link-extra-binaries

os := os()
arch := arch()
arch2 := if arch == "x86_64" { "amd64" } else { arch }
JD := justfile_directory()
GH := "https://github.com"

pulsemixer_ver := "1.5.1"
pulsemixer_fn := "pulsemixer-" + pulsemixer_ver
pulsemixer: \
(_get_tar GH + "/GeorgeFilipkin/pulsemixer/archive/refs/tags/" + pulsemixer_ver + ".tar.gz") \
(_link join(pulsemixer_fn, "pulsemixer") ".local/bin/pulsemixer")

bluetui_ver := "v0.8.1"
bluetui_fn := "bluetui-x86_64-linux-musl"
bluetui: \
(_get_bin GH + "/pythops/bluetui/releases/download/" + bluetui_ver + "/" + bluetui_fn) \
(_link bluetui_fn ".local/bin/bluetui")

monaspace_ver := "v1.400"
monaspace_fn := "monaspace-frozen-" + monaspace_ver
monaspace_output := "Frozen Fonts/Monaspace Argon/MonaspaceArgonFrozen-Regular.ttf"
monaspace: \
(_get_zip GH + "/githubnext/monaspace/releases/download/" + monaspace_ver + "/" + monaspace_fn + ".zip") \
(_link monaspace_output ".local/share/fonts/MonaspaceArgonFrozen-Regular.ttf")
    fc-cache -fv

gdu_ver := "v5.36.1"
gdu_fn := "gdu_linux_" + arch2 + "_static"
gdu: \
(_get_tar GH + "/dundee/gdu/releases/download/" + gdu_ver + "/" + gdu_fn + ".tgz") \
(_link gdu_fn ".local/bin/gdu")

zoxide_ver := "0.10.0"
zoxide_fn := "zoxide-" + zoxide_ver + "-" + arch + "-unknown-" + os + "-musl"
zoxide: \
(_get_output GH + "/ajeetdsouza/zoxide/releases/download/v" + zoxide_ver + "/" + zoxide_fn + ".tar.gz" zoxide_fn "0") \
(_mkdir parent_directory(env("_ZO_DATA_DIR"))) \
(_mkdir ".zoxide/share") \
(_link join(zoxide_fn, "zoxide") ".local/bin/zoxide") \
(_link ".zoxide/share" ".zoxide/share")

cmake_ver := "4.3.3"
cmake_fn := "cmake-" + cmake_ver + "-" + os + "-" + arch
cmake: \
(_get_tar GH + "/Kitware/CMake/releases/download/v" + cmake_ver + "/" + cmake_fn + ".tar.gz") \
(_link join(cmake_fn, "bin/cmake") ".local/bin/cmake") \
(_link join(cmake_fn, "share/bash-completion/completions/cmake") ".local/share/bash-completion/completions/cmake")

gitlfs_ver := "v3.7.1"
gitlfs_fn := "git-lfs-" + os + "-" + arch2 + "-" + gitlfs_ver
gitlfs: \
(_get_output GH + "/git-lfs/git-lfs/releases/download/" + gitlfs_ver + "/" + gitlfs_fn + ".tar.gz" gitlfs_fn "1") \
(_link join(gitlfs_fn, "git-lfs") ".local/bin/git-lfs")
    git lfs install

chafa_ver := "1.18.2-1"
chafa_fn := "chafa-" + chafa_ver + "-" + arch + "-" + os + "-gnu"
chafa: \
(_get_tar "https://hpjansson.org/chafa/releases/static/" + chafa_fn + ".tar.gz") \
(_link join(chafa_fn, "chafa") ".local/bin/chafa")

lazygit_ver := "0.63.0"
lazygit_fn := "lazygit_" + lazygit_ver + "_" + os + "_" + arch
lazygit: \
(_get_output GH + "/jesseduffield/lazygit/releases/download/v" + lazygit_ver + "/" + lazygit_fn + ".tar.gz" lazygit_fn "0") \
(_link join(lazygit_fn, "lazygit") ".local/bin/lazygit")

texlab_ver := "5.26.0"
texlab_fn := "texlab-" + arch + "-" + os
texlab: \
(_get_tar GH + "/latex-lsp/texlab/releases/download/v" + texlab_ver + "/" + texlab_fn + ".tar.gz") \
(_link "texlab" ".local/bin/texlab")

btop_ver := "v1.4.7"
btop_fn := "btop-" + arch + "-unknown-" + os + "-musl"
btop: \
(_get_tar GH + "/aristocratos/btop/releases/download/" + btop_ver + "/" + btop_fn + ".tar.gz") \
(_link "btop/bin/btop" ".local/bin/btop")

fuc_ver := "3.2.0"
fuc_cpz_fn := arch + "-unknown-" + os + "-gnu-cpz"
fuc_rmz_fn := arch + "-unknown-" + os + "-gnu-rmz"
fuc: \
(_get_bin GH + "/SUPERCILEX/fuc/releases/download/" + fuc_ver + "/" + fuc_cpz_fn) \
(_get_bin GH + "/SUPERCILEX/fuc/releases/download/" + fuc_ver + "/" + fuc_rmz_fn) \
(_link fuc_cpz_fn ".local/bin/cpz") \
(_link fuc_rmz_fn ".local/bin/rmz")

helix_ver := "marco_release"
helix_fn := "helix-" + helix_ver + "-" + arch + "-" + os
helix: \
(_get_tar GH + "/mjkpolo/helix/releases/download/" + helix_ver + "/" + helix_fn + ".tar.xz") \
(_link join(helix_fn, "hx") ".local/bin/hx") \
(_link join(helix_fn, "runtime") ".config/helix/runtime") \
(_link join(helix_fn, "contrib/completion/hx.bash") ".local/share/bash-completion/completions/hx.bash")

rg_ver := "15.1.0"
rg_fn := "ripgrep-" + rg_ver + "-" + arch + "-unknown-" + os + "-musl"
rg: \
(_get_tar GH + "/BurntSushi/ripgrep/releases/download/" + rg_ver + "/" + rg_fn + ".tar.gz") \
(_link join(rg_fn, "rg") ".local/bin/rg") \
(_link join(rg_fn, "complete/rg.bash") ".local/share/bash-completion/completions/rg.bash")

fd_ver := "v10.4.2"
fd_fn := "fd-" + fd_ver + "-" + arch + "-unknown-" + os + "-musl"
fd: \
(_get_tar GH + "/sharkdp/fd/releases/download/" + fd_ver + "/" + fd_fn + ".tar.gz") \
(_link join(fd_fn, "fd") ".local/bin/fd") \
(_link join(fd_fn, "autocomplete/fd.bash") ".local/share/bash-completion/completions/fd.bash")

fzf_ver := "0.74.0"
fzf_fn := "fzf-" + fzf_ver + "-" + os + "_" + arch2
fzf: \
(_get_tar GH + "/junegunn/fzf/releases/download/v" + fzf_ver + "/" + fzf_fn + ".tar.gz") \
(_link "fzf" ".local/bin/fzf")

zellij_ver := "1"
zellij_fn := "zellij-no-web-" + arch + "-unknown-" + os + "-musl"
zellij: \
(_get_tar GH + "/mjkpolo/zellij/releases/download/" + zellij_ver + "/" + zellij_fn + ".tar.gz") \
(_link "zellij" ".local/bin/zellij")

uv_ver := "0.11.28"
uv_fn := "uv-" + arch + "-unknown-" + os + "-musl"
uv: \
(_get_tar "https://releases.astral.sh/github/uv/releases/download/" + uv_ver + "/" + uv_fn + ".tar.gz") \
(_mkdir ".cache/uv") \
(_link join(uv_fn, "uv") ".local/bin/uv") \
(_link join(uv_fn, "uvx") ".local/bin/uvx") \
(_link ".cache/uv" ".cache/uv") \
(_link ".venv" ".venv")
    uv venv --clear --python=3.14 .venv

[parallel]
link-dotfiles: \
(_link "env" ".env") \
(_link "bashrc" ".bashrc") \
(_link "dotzellij" ".config/zellij") \
(_link "config.github" "config.github") \
(_link "config.gitlab" "config.gitlab") \
(_link "gitconfig" ".gitconfig") \
(_link "dotzathura" ".config/zathura") \
(_link "dothelix" ".config/helix") \
(_link "dotbtop" ".config/btop") \
(_secret_link "secretenv" ".secretenv")

[parallel]
link-binaries: \
helix \
rg \
fd \
uv \
fzf \
zellij \
fuc \
btop \
lazygit \
gitlfs \
zoxide \
gdu

[parallel]
link-extra-binaries: \
texlab \
cmake \
chafa \
pulsemixer \
bluetui \
monaspace

[parallel]
setup: \
(_mkdir "$HOME/.local/bin") \
(_mkdir "$HOME/.local/lib") \
(_mkdir "$HOME/.local/share/bash-completion/completions") \
(_mkdir "$HOME/.local/share/fonts") \
(_mkdir "$HOME/.config")

_mkdir dir:
    mkdir -p {{dir}}

_get_tar url: setup
    curl --proto '=https' --tlsv1.2 -sSfLO {{url}}
    tar -xf {{file_name(url)}}
    rm -f {{file_name(url)}}

_get_zip url: setup
    curl --proto '=https' --tlsv1.2 -sSfLO {{url}}
    unzip -o {{file_name(url)}}
    rm -f {{file_name(url)}}

_get_output url output strip: setup
    curl --proto '=https' --tlsv1.2 -sSfLO {{url}}
    mkdir -p {{output}}
    tar -xf {{file_name(url)}} -C {{output}} --strip-components={{strip}}
    rm -f {{file_name(url)}}

_get_bin url: setup
    curl --proto '=https' --tlsv1.2 -sSfLO {{url}}
    chmod +x {{file_name(url)}}

[script("bash")]
_link source dest: setup
    echo "Linking $JD/$source -> $HOME/$dest"
    [[ -e "$HOME/$dest" ]] && { unlink "$HOME/$dest" || rm -rf "$HOME/$dest"; }
    ln -sf "$JD/$source" "$HOME/$dest"

[script("bash")]
_secret_link source dest: setup
    if [[ -f "$JD/$source" ]]; then
        echo "Linking $JD/$source -> $HOME/$dest"
        [[ -e "$HOME/$dest" ]] && { unlink "$HOME/$dest" || rm -rf "$HOME/$dest"; }
        ln -sf "$JD/$source" "$HOME/$dest"
    fi
