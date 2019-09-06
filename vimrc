set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()
"
 " Plugin 'VundleVim/Vundle.vim'
"  Plugin 'wakatime/vim-wakatime'
 " Plugin 'tpop/vim-endwise'
"call vundle#end()            " required
"filetype plugin indent on    " required

syntax on
set backspace=indent,eol,start
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard=unnamed
set showcmd
set cursorline
set showmatch
set noerrorbells
set title

" move vertically by visual line
nnoremap j gj
nnoremap k gk

if has("multi_byte")
  set encoding=utf-8
  setglobal fileencoding=utf-8
else
  echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

"call plug#begin()
"Plug 'terryma/vim-multiple-cursors'
"
"
"call plug#end()
