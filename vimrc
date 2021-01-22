call plug#begin('~/.vim/plugged')
" Essentials
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
" Theme
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
" Conjure for Clojure
Plug 'Olical/conjure', {'tag': 'v4.10.0'}
Plug 'clojure-vim/vim-jack-in'
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'
" COC and Nerdtree
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" fzf
map ; :Files<CR>

" Nerdtree
nnoremap <C-n> :NERDTreeToggle<CR>

" COC.nvim
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> gd <Plug>(coc-definition)
nmap <leader>rn <Plug>(coc-rename)

" Theme
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark='hard'
let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ }

" Tagbar
map <C-b> :TagbarToggle<CR>

" borrowed geohot config
syntax on
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set ai
set number
set hlsearch
set ruler

" Personal Config
tnoremap <Esc> <C-\><C-n>
set pastetoggle=<F3>
set mouse=a

autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
