" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif
inoremap jk <ESC>

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Line numbers
set number 

" Auto-indent 4 spaces when coding
" Does NOT change tab into 4 spaces
set shiftwidth=4

" Always replace tab with 8 spaces, except for makefiles
set expandtab
autocmd FileType make setlocal noexpandtab

" Editing *.txt files
" -automatically indent lines accoding to previous lines
" -replace tab with 8 spaces
" -when hit tab key, move 2 spaces instead of 8
" -wrap text if longer than 76 columns
" -check spelling
autocmd FileType text setlocal autoindent expandtab softtabstop=2 textwidth=76 spell spelllang=en_us

" Don't do spell-checking on Vim help files
autocmd FileType help setlocal nospell

" Prepend ~/. backup to backupdir so that Vim will look for that directory
" before littering current dir with backups.
" You need to do 'mkdir ~/.backup' for this to work
set backupdir^=~/.backup

" Also use ~/.backup for swap files. The trailing // tells Vim to incorporate
" full path to swap file names. 
set dir^=~/.backup//

" Ignore case when searching 
" -override this by setting tacking on \c or \C to your search term to make
"  your search always case=insensitive or case-sensitive, respectively.
set ignorecase

" Set a colored vertical line on the 80th character
set colorcolumn=80

" Set color column to a specific color
highlight colorcolumn ctermbg=7

" Set color scheme
colorscheme desert

" Set leader key
let mapleader = ","

" Run rustfmt on save
let g:rustfmt_autosave = 1

" cmd remap
nnoremap <silent> <c-f> :FZF<cr>
nnoremap <silent> <c-a> :Ag<cr>
nnoremap <silent> <c-g> :Rg<cr>
nnoremap <silent> <c-h> :History<cr>
nnoremap <silent> <c-d> :GoDef<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'xolox/vim-misc'

Plug 'davidhalter/jedi-vim'

Plug 'rust-lang/rust.vim'

Plug 'github/copilot.vim'

Plug 'numine777/py-bazel.nvim'

Plug 'alexander-born/bazel.nvim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

function! MaybeSetGoPackagesDriver()
  " Start at the current directory and see if there's a WORKSPACE file in the
  " current directory or any parent. If we find one, check if there's a
  " gopackagesdriver.sh in a tools/ directory, and point our
  " GOPACKAGESDRIVER env var at it.
  let l:dir = getcwd()
  while l:dir != "/"
    if filereadable(simplify(join([l:dir, 'MODULE.bazel'], '/')))
      let l:maybe_driver_path = simplify(join([l:dir, 'tools/gopackagesdriver.sh'], '/'))
      if filereadable(l:maybe_driver_path)
        let $GOPACKAGESDRIVER = l:maybe_driver_path
        break
      end
    end
    let l:dir = fnamemodify(l:dir, ':h')
  endwhile
endfunction

call MaybeSetGoPackagesDriver()

let g:go_def_mode = 'gopls'
let g:go_info_mode = 'gopls'
let g:go_import_mode = 'gopls'
" See https://github.com/golang/tools/blob/master/gopls/doc/settings.md
let g:go_gopls_settings = {
  \ 'build.directoryFilters': [
    \ '-bazel-bin',
    \ '-bazel-out',
    \ '-bazel-testlogs',
    \ '-bazel-mycorr',
  \ ],
  \ 'ui.completion.usePlaceholders': v:true,
  \ 'ui.semanticTokens': v:true,
  \ 'ui.codelenses': {
    \ 'gc_details': v:false,
    \ 'regenerate_cgo': v:false,
    \ 'generate': v:false,
    \ 'test': v:false,
    \ 'tidy': v:false,
    \ 'upgrade_dependency': v:false,
    \ 'vendor': v:false,
  \ },
\ }
