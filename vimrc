syntax on
set backspace=indent,eol,start
set number
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard=unnamed

if has("multi_byte")
  set encoding=utf-8
  setglobal fileencoding=utf-8
else
  echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif
