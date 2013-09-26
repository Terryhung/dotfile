" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: Bert
"             lazywei AT github
" Sections:
"    -> General Settings
"    -> Load plugins via Vundle
"    -> VIM user interface
"    -> More tweaks
"    -> Custom mappings
"        -> Inser mode
"        -> Nomal mode
"        -> Visual mode
"        -> Command mode
"
"    -> Plugins settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" We reset the vimrc augroup.
" Autocommands are added to this group throughout the file
augroup vimrc
  autocmd!
augroup END

let mapleader = ","

" In normal mode, we use : much more often than ; so lets swap them.
" WARNING: this will cause any "ordinary" map command without the "nore" prefix
" that uses ":" to fail. For instance, "map <f2> :w" would fail, since vim will
" read ":w" as ";w" because of the below remappings. Use "noremap"s in such
" situations and you'll be fine.
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" Enable filetype plugin
filetype plugin on
filetype indent on


set autoindent                 " on new lines, match indent of previous line
set autoread                   " auto read when a file is changed from the outside
set backspace=indent,eol,start " Allow backspacing over everything in insert mode
set cindent                    " smart indenting for c-like code
set cino=b1,g0,N-s,t0,(0,W4    " see :h cinoptions-values

" The "longest" option makes completion insert the longest prefix of all
" the possible matches; see :h completeopt
set completeopt=menu,menuone,longest

set copyindent                 " copy the previous indentation on autoindenting
set expandtab                  " turn a tab into spaces
set encoding=utf8
set fileformat=unix            " file mode is unix
set fileformats=unix,dos,mac   " detects unix, dos, mac file formats in that order
set hidden                     " allows making buffers hidden even with unsaved changes
set history=1000               " remember more commands and search history
set hlsearch                   " Highlight search things
set ignorecase                 " case insensitive searching
set laststatus=2               " the statusline is now always shown
set linebreak
set incsearch                  " Make search act like search in modern browsers
set magic                      " change the way backslashes are used in search patterns
set mouse=a                    " enables the mouse in all modes
set nobackup                   " no backup~ files.
set nowb
set noswapfile
set noshowmode                 " Don't show the mode ("-- INSERT --") at the bottom
set nolazyredraw               " Don't redraw while executing macros 
set shiftround                 " makes indenting a multiple of shiftwidth
set shiftwidth=2               " spaces for autoindents
set smartcase                  " but become case sensitive if you type uppercase characters
set smarttab                   " smart tab handling for indenting
set softtabstop=2
set switchbuf=useopen,usetab
set tabstop=2                  " number of spaces a tab counts for
set timeoutlen=500             " Timeout for mapping
set undolevels=1000            " use many levels of undo
set viminfo='20,\"500          " remember copy registers after quitting in the .viminfo
" file -- 20 jump links, regs up to 500 lines'

" When you type the first tab, it will complete as much as possible, the second
" tab hit will provide a list, the third and subsequent tabs will cycle through
" completion options so you can complete the file without further keys
set wildmode=longest,list,full
set wildmenu                   " completion with menu
set wrap                       " Wrap lines
set whichwrap+=<,>,h,l,[,]

func! MySys()
  return "mac"
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Load plugins via Vundle
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Needed for vundle, will be turned on after vundle inits
filetype off

" Setup vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

if filereadable(expand("~/.vim/vundles.vim"))
  source ~/.vim/vundles.vim
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme valloric
syntax enable
set scrolloff=7     " Set the distance to scroll when moving cursor 
set ruler           " Always show current position
set cmdheight=2     " The commandbar height
set showmatch       " Show matching bracets when text indicator is over them
set mat=2           " How many tenths of a second to blink
set nu

if MySys() == "mac"
  set gfn=Menlo:h16
  set shell=/bin/zsh
elseif MySys() == "windows"
  set gfn=Bitstream\ Vera\ Sans\ Mono:h10
elseif MySys() == "linux"
  set gfn=Monaco\ 14
  set shell=/bin/zsh
endif

if has("gui_running")
  set guioptions-=T "remove toolbar
  set guioptions-=r "remove right-hand scroll bar
  set guioptions-=R
  set guioptions-=L "remove left-hand scrollbar which is present when there is a vertically split window
  set guioptions-=l
  set guioptions-=M
  set guioptions-=m "remove menu
  set t_Co=256
  set cursorline " highlight current line
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => More tweaks
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Unicode support (taken from http://vim.wikia.com/wiki/Working_with_Unicode)
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif

augroup vimrc
  " Automatically delete trailing DOS-returns and whitespace on file open and
  " write.
  autocmd BufRead,BufWritePre,FileWritePre * silent! %s/[\r \t]\+$//
augroup END

function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        execute "Ack " . l:pattern . ' %'
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"Basically you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
vnoremap <silent> gv :call VisualSearch('gv')<CR>

autocmd vimrc FileType text,markdown,gitcommit set nocindent
" Auto turn on spell check for markdown file, gitcommit
autocmd vimrc FileType markdown setlocal spell! spelllang=en_us
autocmd vimrc FileType gitcommit setlocal spell! spelllang=en_us

try
  lang zh_TW
catch
endtry

" Persistent undo
try
  if MySys() == "windows"
    set undodir=C:\Windows\Temp
  else
    set undodir=~/.vim/undodir
  endif

  set undofile
catch
endtry

" Auto go to the location last time edit when open files.
if has("autocmd")
  autocmd BufRead *.txt set tw=78
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal g'\"" |
        \ endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     => Inser mode
"     => Nomal mode
"     => Visual mode
"     => Command mode


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
