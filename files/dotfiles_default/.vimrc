"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""
""" ATTENTION: THIS FILE IS MANAGED BY PUPPET
"""
""" ANY CHANGE WILL BE REVERTED AUTOMATICALLY ON NEXT PUPPET RUN
"""
""" If you want to run your own dotfiles, specify another configuration directory
""" source for hosting_basesetup::usermanagement::user => dotfile_sourcedir

if &t_Co > 1
	syn on
	set bg=dark
endif
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
set wrap
set ignorecase
autocmd BufRead *.cc,*.c,*.h set smartindent ts=2 sw=2 sta et sts=2 ai
autocmd BufRead *.sh set smartindent cinwords=if,else,for,do,while ts=2 sw=2 sta et sts=2 ai
autocmd BufRead *.pp set smartindent ts=2 sw=2 sta et sts=2 ai
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class ts=2 sw=2

set showmatch

" Tabstop options
" when inserting TABs replace them with the appropriate
" number of spaces
set expandtab
set shiftwidth=3
set tabstop=3
"" C-style indenting
set cindent
set cinkeys-=0#
set indentkeys-=0#

set modeline
set wildmenu

" Pastemode mit F12 toggeln
nmap <F12> :if(&paste)<CR>set nopaste<CR>else<CR>set paste<CR>endif<CR><CR>


map <C-left> :tabp<cr>
map <C-right> :tabn<cr>
imap <C-left>  <ESC>:tabp<CR>i
imap <C-right> <ESC>:tabn<CR>i
set tabpagemax=30


" enable syntax highlighting
syntax on
color delek

"""
""" ATTENTION: THIS FILE IS MANAGED BY PUPPET
"""
""" ANY CHANGE WILL BE REVERTED AUTOMATICALLY ON NEXT PUPPET RUN
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
