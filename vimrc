syntax on
set cursorline

set number
set history=10000
set backspace=indent,eol,start
set tabstop=2 shiftwidth=2 expandtab
set autoindent

if has("multi_byte")
  set encoding=utf-8
  setglobal fileencoding=utf-8
else
  echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif
set autoindent
augroup vimrcEx
  autocmd BufReadPost *
    \ if line("'\"") > 0 && ("'\"") <= line("$") | 
    \   exe "normal g`\"" |
    \ endif

  autocmd Filetype ruby,erb,haml, html, javascript set ai sw=2 sts=2 et

  function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
      return "\<tab>"
    else
      return "\<c-p>"
    endif
  endfunction

  inoremap <tab> <c-r>=InsertTabWrapper()<cr>
  inoremap <s-tab> <c-n>

