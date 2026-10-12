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

arch := arch()
arch2 := if arch == "x86_64" { "amd64" } else { if arch == "aarch64" { "arm64" } else { arch } }
arch3 := if arch == "x86_64" { "x64" } else { arch }
JD := justfile_directory()
GH := "https://github.com"

pulsemixer_ver := "1.5.1"
pulsemixer_output := "pulsemixer-" + pulsemixer_ver
[linux]
pulsemixer: \
(_get_tar GH + "/GeorgeFilipkin/pulsemixer/archive/refs/tags/" + pulsemixer_ver + ".tar.gz") \
(_link join(pulsemixer_output, "pulsemixer") ".local/bin/pulsemixer")

bluetui_ver := "v0.8.1"
[linux]
bluetui: \
(_get_bin GH + "/pythops/bluetui/releases/download/" + bluetui_ver + "/bluetui-x86_64-linux-musl" "bluetui") \
(_link "bluetui" ".local/bin/bluetui")

monaspace_ver := "v1.400"
monaspace_output := "Frozen Fonts/Monaspace Argon/MonaspaceArgonFrozen-Regular.ttf"
monaspace: \
(_get_zip GH + "/githubnext/monaspace/releases/download/" + monaspace_ver + "/monaspace-frozen-" + monaspace_ver + ".zip") \
(_link monaspace_output ".local/share/fonts/MonaspaceArgonFrozen-Regular.ttf")
    fc-cache -fv

gdu_ver := "v5.36.1"
gdu_output := "gdu-" + gdu_ver
gdu: \
_get_gdu \
(_link join(gdu_output, "gdu") ".local/bin/gdu")

[linux]
_get_gdu: \
(_get_tar_output GH + "/dundee/gdu/releases/download/" + gdu_ver + "/gdu_linux_" + arch2 + ".tgz" gdu_output "0")
    mv "{{gdu_output}}/gdu_linux_{{arch2}}" "{{gdu_output}}/gdu"

[macos]
_get_gdu: \
(_get_tar_output GH + "/dundee/gdu/releases/download/" + gdu_ver + "/gdu_darwin_" + arch2 + ".tgz" gdu_output "0")
    mv "{{gdu_output}}/gdu_darwin_{{arch2}}" "{{gdu_output}}/gdu"

zoxide_ver := "0.10.0"
zoxide_output := "zoxide-" + zoxide_ver
zoxide: \
_get_zoxide \
(_mkdir parent_directory(env("_ZO_DATA_DIR"))) \
(_mkdir ".zoxide/share") \
(_link join(zoxide_output, "zoxide") ".local/bin/zoxide") \
(_link ".zoxide/share" ".zoxide/share")

[linux]
_get_zoxide: \
(_get_tar_output GH + "/ajeetdsouza/zoxide/releases/download/v" + zoxide_ver + "/zoxide-" + zoxide_ver + "-" + arch + "-unknown-linux-musl.tar.gz" zoxide_output "0")

[macos]
_get_zoxide: \
(_get_tar_output GH + "/ajeetdsouza/zoxide/releases/download/v" + zoxide_ver + "/zoxide-" + zoxide_ver + "-" + arch + "-apple-darwin.tar.gz" zoxide_output "0")

cmake_ver := "4.3.3"
cmake_output := "cmake-" + cmake_ver
cmake: \
_get_cmake \
(_link join(cmake_output, "bin/cmake") ".local/bin/cmake") \
(_link join(cmake_output, "share/bash-completion/completions/cmake") ".local/share/bash-completion/completions/cmake")

[linux]
_get_cmake: \
(_get_tar_output GH + "/Kitware/CMake/releases/download/v" + cmake_ver + "/cmake-" + cmake_ver + "-linux-" + arch + ".tar.gz" cmake_output "1")

[macos]
_get_cmake: \
(_get_tar_output GH + "/Kitware/CMake/releases/download/v" + cmake_ver + "/cmake-" + cmake_ver + "-macos-" + arch + ".tar.gz" cmake_output "1")

gitlfs_ver := "v3.8.0"
gitlfs_output := "git-lfs-" + gitlfs_ver
gitlfs: \
_get_gitlfs \
(_link join(gitlfs_output, "git-lfs") ".local/bin/git-lfs")
    git lfs install

[linux]
_get_gitlfs: \
(_get_tar_output GH + "/git-lfs/git-lfs/releases/download/" + gitlfs_ver + "/git-lfs-linux-" + arch2 + "-" + gitlfs_ver + ".tar.gz" gitlfs_output "1")

[macos]
_get_gitlfs: \
(_get_zip_output GH + "/git-lfs/git-lfs/releases/download/" + gitlfs_ver + "/git-lfs-darwin-" + arch2 + "-" + gitlfs_ver + ".zip" gitlfs_output "*/git-lfs")

chafa_ver := "1.18.2-1"
chafa_output := "chafa-" + chafa_ver
[linux]
chafa: \
(_get_tar_output "https://hpjansson.org/chafa/releases/static/chafa-" + chafa_ver + "-" + arch + "-linux-gnu.tar.gz" chafa_output "1") \
(_link join(chafa_output, "chafa") ".local/bin/chafa")

lazygit_ver := "0.66.1"
lazygit_output := "lazygit_" + lazygit_ver
lazygit: \
_get_lazygit \
(_link join(lazygit_output, "lazygit") ".local/bin/lazygit")

[linux]
_get_lazygit: \
(_get_tar_output GH + "/jesseduffield/lazygit/releases/download/v" + lazygit_ver + "/lazygit_" + lazygit_ver + "_linux_" + arch + ".tar.gz" lazygit_output "0")

[macos]
_get_lazygit: \
(_get_tar_output GH + "/jesseduffield/lazygit/releases/download/v" + lazygit_ver + "/lazygit_" + lazygit_ver + "_darwin_" + arch2 + ".tar.gz" lazygit_output "0")

texlab_ver := "5.26.0"
texlab: \
_get_texlab \
(_link "texlab" ".local/bin/texlab")

[linux]
_get_texlab: \
(_get_tar GH + "/latex-lsp/texlab/releases/download/v" + texlab_ver + "/texlab-" + arch + "-linux.tar.gz")

[macos]
_get_texlab: \
(_get_tar GH + "/latex-lsp/texlab/releases/download/v" + texlab_ver + "/texlab-" + arch + "-macos.tar.gz")

btop_ver := "v1.4.7"
[linux]
btop: \
(_get_tar GH + "/aristocratos/btop/releases/download/" + btop_ver + "/btop-" + arch + "-unknown-linux-musl.tar.gz") \
(_link "btop/bin/btop" ".local/bin/btop")

fuc_ver := "3.2.0"
[linux]
fuc: \
(_get_bin GH + "/SUPERCILEX/fuc/releases/download/" + fuc_ver + "/" + arch + "-unknown-linux-gnu-cpz" "cpz") \
(_get_bin GH + "/SUPERCILEX/fuc/releases/download/" + fuc_ver + "/" + arch + "-unknown-linux-gnu-rmz" "rmz") \
(_link "cpz" ".local/bin/cpz") \
(_link "rmz" ".local/bin/rmz")

helix_ver := "marco_release"
helix_output := "helix-" + helix_ver
helix: \
_get_helix \
(_link join(helix_output, "hx") ".local/bin/hx") \
(_link join(helix_output, "runtime") ".config/helix/runtime") \
(_link join(helix_output, "contrib/completion/hx.bash") ".local/share/bash-completion/completions/hx.bash")

[linux]
_get_helix: \
(_get_tar_output GH + "/mjkpolo/helix/releases/download/" + helix_ver + "/helix-" + helix_ver + "-" + arch + "-linux.tar.xz" helix_output "1")

[macos]
_get_helix: \
(_get_tar_output GH + "/mjkpolo/helix/releases/download/" + helix_ver + "/helix-" + helix_ver + "-" + arch + "-macos.tar.xz" helix_output "1")

rg_ver := "15.2.0"
rg_output := "ripgrep-" + rg_ver
rg: \
_get_rg \
(_link join(rg_output, "rg") ".local/bin/rg") \
(_link join(rg_output, "complete/rg.bash") ".local/share/bash-completion/completions/rg.bash")

[linux]
_get_rg: \
(_get_tar_output GH + "/BurntSushi/ripgrep/releases/download/" + rg_ver + "/ripgrep-" + rg_ver + "-" + arch + "-unknown-linux-musl.tar.gz" rg_output "1")

[macos]
_get_rg: \
(_get_tar_output GH + "/BurntSushi/ripgrep/releases/download/" + rg_ver + "/ripgrep-" + rg_ver + "-" + arch + "-apple-darwin.tar.gz" rg_output "1")

fd_ver := "v10.5.0"
fd_output := "fd-" + fd_ver
fd: \
_get_fd \
(_link join(fd_output, "fd") ".local/bin/fd") \
(_link join(fd_output, "autocomplete/fd.bash") ".local/share/bash-completion/completions/fd.bash")

[linux]
_get_fd: \
(_get_tar_output GH + "/sharkdp/fd/releases/download/" + fd_ver + "/fd-" + fd_ver + "-" + arch + "-unknown-linux-musl.tar.gz" fd_output "1")

[macos]
_get_fd: \
(_get_tar_output GH + "/sharkdp/fd/releases/download/" + fd_ver + "/fd-" + fd_ver + "-" + arch + "-apple-darwin.tar.gz" fd_output "1")

fzf_ver := "0.74.5"
fzf: \
_get_fzf \
(_link "fzf" ".local/bin/fzf")

[linux]
_get_fzf: \
(_get_tar GH + "/junegunn/fzf/releases/download/v" + fzf_ver + "/fzf-" + fzf_ver + "-linux_" + arch2 + ".tar.gz")

[macos]
_get_fzf: \
(_get_tar GH + "/junegunn/fzf/releases/download/v" + fzf_ver + "/fzf-" + fzf_ver + "-darwin_" + arch2 + ".tar.gz")

zellij_ver := "1"
zellij: \
_get_zellij \
(_link "zellij" ".local/bin/zellij")

[linux]
_get_zellij: \
(_get_tar GH + "/mjkpolo/zellij/releases/download/" + zellij_ver + "/zellij-no-web-" + arch + "-unknown-linux-musl.tar.gz")

[macos]
_get_zellij: \
(_get_tar GH + "/mjkpolo/zellij/releases/download/" + zellij_ver + "/zellij-no-web-" + arch + "-apple-darwin.tar.gz")

uv_ver := "0.13.0"
uv_output := "uv-" + uv_ver
uv: \
_get_uv \
(_mkdir ".cache/uv") \
(_link join(uv_output, "uv") ".local/bin/uv") \
(_link join(uv_output, "uvx") ".local/bin/uvx") \
(_link ".cache/uv" ".cache/uv") \
(_link ".venv" ".venv")
    uv venv --clear --python=3.14 .venv

[linux]
_get_uv: \
(_get_tar_output "https://releases.astral.sh/github/uv/releases/download/" + uv_ver + "/uv-" + arch + "-unknown-linux-musl.tar.gz" uv_output "1")

[macos]
_get_uv: \
(_get_tar_output "https://releases.astral.sh/github/uv/releases/download/" + uv_ver + "/uv-" + arch + "-apple-darwin.tar.gz" uv_output "1")

ltex_ls_plus_ver := "18.7.0"
ltex_ls_plus_ver_output := "ltex-ls-plus-" + ltex_ls_plus_ver
ltex_ls_plus: \
_get_ltex_ls_plus \
(_link join(ltex_ls_plus_ver_output, "bin/ltex-ls-plus") ".local/bin/ltex-ls-plus") \
(_link join(ltex_ls_plus_ver_output, "bin/ltex-cli-plus") ".local/bin/ltex-cli-plus")

[linux]
_get_ltex_ls_plus: \
(_get_tar "https://github.com/ltex-plus/ltex-ls-plus/releases/download/" + ltex_ls_plus_ver + "/ltex-ls-plus-" + ltex_ls_plus_ver + "-linux-" + arch3 + ".tar.gz")

[macos]
_get_ltex_ls_plus: \
(_get_tar "https://github.com/ltex-plus/ltex-ls-plus/releases/download/" + ltex_ls_plus_ver + "/ltex-ls-plus-" + ltex_ls_plus_ver + "-mac-" + arch + ".tar.gz")

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
lazygit \
gitlfs \
zoxide \
gdu

[parallel]
link-extra-binaries: \
texlab \
ltex_ls_plus \
cmake \
monaspace \
_link_extra_platform_binaries

[linux]
[parallel]
_link_extra_platform_binaries: \
btop \
fuc \
chafa \
pulsemixer \
bluetui

[macos]
_link_extra_platform_binaries:

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

_get_zip_output url output member: setup
    curl --proto '=https' --tlsv1.2 -sSfLO {{url}}
    mkdir -p {{output}}
    unzip -o -j {{file_name(url)}} '{{member}}' -d {{output}}
    rm -f {{file_name(url)}}

_get_tar_output url output strip: setup
    curl --proto '=https' --tlsv1.2 -sSfLO {{url}}
    mkdir -p {{output}}
    tar -xf {{file_name(url)}} -C {{output}} --strip-components={{strip}}
    rm -f {{file_name(url)}}

_get_bin url output: setup
    curl --proto '=https' --tlsv1.2 -sSfL {{url}} -o {{output}}
    chmod +x {{output}}

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
