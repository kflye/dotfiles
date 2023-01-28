"Use vim settings instead of vi, do not move this line
set nocompatible    " disable compatibility to old-time vi

set fileformat=unix "Set file format to unix (:set ff?) to show fileformat - dos CRLF on windows

filetype on
filetype plugin on
filetype indent on

let mapleader=" "

syntax on

set history=100         
set hidden                  " It hides buffers instead of closing them. You can have unwritten changes to a file and open a new file, without being forced to write or undo your changes first
set noerrorbells
"set belloff=all

" Smart search with ignorecase + smartcase, lowercase searches case insensitive, uppercase is case sensitive
set ignorecase
set smartcase

set autoindent              " indent a new line the same amount as the line just typed
set smartindent             " Smart indent, e.g. after {. Works in combination with autoindent

set nohlsearch              " do not highlight search result
set incsearch               " incremental search, go to match before pressing enter
set number relativenumber   " add line numbers (relative)

" tabs + indent
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing   
set tabstop=4               " number of columns occupied by a tab
set shiftwidth=4            " width for autoindents
set expandtab               " Expand tab to spaces

set scrolloff=8             " Minimal number of screen lines to keep above and below the cursor 
set cursorline              " Highlight current line

" Use persistent history. (U)
set undodir=~/.vim/undo-dir
set undofile
set noswapfile
set nobackup

" enhanced command-line completion
" set wildmenu

"Make tab not drop selectin
vnoremap < <gv
vnoremap > >gv

" Map 0 to go to the first charactor of the line
nnoremap 0 g^

" auto install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" run PlugInstall / PlugUpdate in command mode
call plug#begin()
    "Plugin Section
    
    " nerdtree + devicon support for nerdtree
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'

    " Replace deleted/yanked text: gr{motion}
    Plug 'vim-scripts/ReplaceWithRegister'

    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " Theme 
    Plug 'gruvbox-community/gruvbox'

    " Highlight yanked text not needed for neovim
    Plug 'machakann/vim-highlightedyank'

    "Plug 'SirVer/ultisnips'
    "Plug 'honza/vim-snippets'
    "Plug 'preservim/nerdcommenter'
    "Plug 'mhinz/vim-startify'
    "Plug 'neoclide/coc.nvim', {'branch': 'release'} "a fast code completion engine
call plug#end()

colorscheme gruvbox

au TextYankPost * silent! lua vim.highlight.on_yank()

" Shortcuts
nnoremap x "_x
nnoremap X "_X

" Move line up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" disable ctrl+z on windows - suspends vim on linux - crash on windows
if has("win32") && has("nvim")
  nnoremap <C-z> <nop>
  inoremap <C-z> <nop>
  vnoremap <C-z> <nop>
  snoremap <C-z> <nop>
  xnoremap <C-z> <nop>
  cnoremap <C-z> <nop>
  onoremap <C-z> <nop>
endif

" disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" remap line change, why?
"nnoremap j gj
"nnoremap k gk

" fzf
noremap <silent> <C-p> :Files<CR>
