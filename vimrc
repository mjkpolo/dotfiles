call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jnurmine/Zenburn'
" Conjure for Clojure
Plug 'Olical/conjure', {'tag': 'v4.10.0'}
Plug 'clojure-vim/vim-jack-in'
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'
" Deoplete and Ale
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'tweekmonster/deoplete-clang2'
Plug 'dense-analysis/ale'
call plug#end()

" Deoplete
let g:deoplete#enable_at_startup = 1
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" fzf
map ; :Files<CR>

" Theme
colorscheme zenburn
let g:airline_theme='zenburn'
set termguicolors

" Tagbar
map <C-b> :TagbarToggle<CR>


" geohot config
syntax on
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set ai
set number
set hlsearch
set ruler

" Personal Config
set pastetoggle=<F3>
set mouse=a

autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd filetype java nnoremap <F5> :w <bar> !cd %:h && javac *.java <CR>
autocmd filetype java nnoremap <F9> :w <bar> !cd %:h && java %:t:r <CR>
autocmd filetype java nnoremap <F11> :w <bar> !cd %:h && ant compile jar run <CR>

augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
