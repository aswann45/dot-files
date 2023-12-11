" Vim with all enhancements -- from default Windows configuration
" source $VIMRUNTIME/vimrc_example.vim " ---------------
" Check operating system
" ---------------
function! MySys()
    if has('win32')
        return 'windows'
    else
        return 'linux'
    endif
endfunction

" ----------------
" Set Python dll for vim build
" Target correct files for operating system
" ----------------
let data_dir = ''

if MySys() == 'windows' 
    if $HOME == 'C:\Users\testpc'
        let data_dir = 'C:/Users/testpc/Vim/vimfiles'
        set g:pythonthreedll=c:\\Users\\testpc\\AppData\\Local\\Programs\\Python\\Python310\\python310.dll
        set g:pythonthreehome=c:\\Users\\testpc\\AppData\\Local\\Programs\\Python\\Python310
    else
	let data_dir = 'C:/Users/aswann2/Vim/vimfiles'
        set g:pythonthreedll=c:\\Users\\aswann2\\AppData\\Local\\Programs\\Python\\Python310\\python310.dll
        set g:pythonthreehome=c:\\Users\\aswann2\\AppData\\Local\\Programs\\Python\\Python310
    endif
    "set shellslash
else
    let data_dir = '~/.vim'
endif

" ----------------
"  True colors
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux. 
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support 
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.) 
if (empty($TMUX))   
    if (has("nvim"))     
        "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >     
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1   
    endif   
	"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >   
	"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >   " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >   
    if (has("termguicolors"))     
        set termguicolors   
    endif     
endif

" ----------------
" Plugins
" ----------------
" Install vim-plug if not found
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin(data_dir.'/plugged')

" List plugins here
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Valloric/YouCompleteMe'
Plug 'vim-scripts/indentpython.vim'
" Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'Exafunction/codeium.vim'
Plug 'dense-analysis/ale'
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }

" Color Schemes managed by vim-plug
Plug 'tomasr/molokai'
Plug 'NLKNguyen/papercolor-theme'
Plug 'altercation/vim-colors-solarized'
Plug 'jnurmine/Zenburn'
Plug 'joshdick/onedark.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

" Initialize plugin system
call plug#end()

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" ----------------
" Splits 
" ----------------
set splitbelow
set splitright

" split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" ----------------
" Code folding
" ----------------
set foldmethod=indent
set foldlevel=99

" fold with spacebar
nnoremap <space> za

" show docstrings for folded code
" with SimpylFold
" let g:SimplyFold_docstring_preview=1

" ----------------
" PEP 8 Indendtation
" ----------------
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 | 
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set colorcolumn=80 

" ----------------
" Web Development Indendtation
" ----------------
au BufNewFile,BufRead *.js,*.html,*.css 
    \ set tabstop=2 | 
    \ set softtabstop=2 | 
    \ set shiftwidth=2 

"  ----------------
"  Markdown Indentation
"  ----------------
au BufNewFile,BufRead *.md
    \ set tabstop=2 | 
    \ set softtabstop=2 | 
    \ set shiftwidth=2 |
    \ set shiftround |
    \ set expandtab |
    \ set linebreak |
    \ set formatoptions-=t |
    \ set columns=80

" ----------------
" UTF-8 support
" ----------------
set encoding=utf-8
"set fileencoding=utf-8

" ----------------
" Flag bad whitespace
" ----------------
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.js,*.md,*.css match BadWhitespace /\s\+$/

" ----------------
" YouCompleteMe tweaks
" ----------------
" make the auto-complete window go away when we're done
let g:ycm_autoclose_preview_window_after_completion=1

" shortcut for goto definition
map <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

" ----------------
" Virtualenv support
" ----------------
python3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    exec(open(activate_this).read(), dict(__file__=activate_this))
EOF

" ----------------
"  ALE stuff
"  ----------------
" set ale_use_colors=1
let g:ale_linters = {
     \   'python': ['flake8', 'jedils', 'mypy', 'vulture'],
     \   'javascript': ['eslint'],
     \   'markdown': ['remark-lint'],
     \   'yaml': ['prettier'],
     \}

let g:ale_fixers = {
     \   'python': ['black'],
     \   'javascript': ['eslint'],
     \   'css': ['prettier'],
     \   'html': ['prettier'],
     \   'json': ['prettier'],
     \   'xml': ['prettier'],
     \   'yaml': ['prettier'],
     \   'markdown': ['remark-lint'],
     \   '*': ['remove_trailing_lines', 'trim_whitespace'],
     \}
" black formatting settings
let g:ale_python_black_options='--line-length=79'
" vulture settings
let g:python_vulture_use_global = 1
" enable automatic linting
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
" disable automatic fixing
let g:ale_fix_on_save = 0
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'
" remark-lint setup
let g:ale_markdown_remark_lint_use_global = 1
let g:ale_markdown_remark_lint_options = '-r ~/.remarkrc.yml'

map <leader>; :ALENextWrap<CR>
map <leader>' :ALEPreviousWrap<CR>
map <leader>f :ALEFix<CR>

" ----------------
" Syntax highlighting
" ----------------
" uses Syntastic and Vim-flake8
"let python_highlight_all=1
syntax on

" ----------------
" Colorscheme and colors
" ----------------
" enable 256 colors
set t_Co=256
set t_ut=

set background=dark
colorscheme catppuccin_frappe
"colorscheme molokai
"colorscheme PaperColor
"colorscheme solarized
"colorscheme zenburn
"colorscheme onedark

" lightline
set noshowmode
" let g:lightline = {'colorscheme' : 'PaperColor'}
let g:lightline = {'colorscheme' : 'catppuccin_macchiato'}

" ----------------
" Line numbering
" ----------------
set number

" ----------------
" File Browsing
" ----------------
" toggle NERDTree
let NERDTreeMinimalUI = 1
map <leader>n :NERDTreeTabsToggle<CR>

" Ignore files in NERDTree
let NERDTreeIgnore=['\.pyc$', '__pycache__']


let g:NERDTreeGitStatusIndicatorMapCustom = {
       			\ 'Modified'  :'●',
       			\ 'Staged'    :'✚',                 
			\ 'Untracked' :'✭',                 
			\ 'Renamed'   :'➜',                 
			\ 'Unmerged'  :'═',                 
			\ 'Deleted'   :'✖',                 
			\ 'Dirty'     :'✗',                 
			\ 'Ignored'   :'☒',                 
			\ 'Clean'     :'✔︎',                 
			\ 'Unknown'   :'?',                 
			\ }
" ---------------
" System Clipboard
" ---------------
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"pa

" ----------------
" Status bar 
" ----------------
" set up Powerline
" python3 from powerline.vim import setup as powerline_setup
" python3 powerline_setup()
" python3 del powerline_setup

" always show
set laststatus=2

" ----------------
" Backspacing 
" ----------------
"
set backspace=indent,eol,start

" ----------------
" Codeium custom keybindings
" ----------------
let g:codeium_no_map_tab = 1
imap <script><silent><nowait><expr> <C-g> codeium#Accept()
" inoremap <C-;> <Cmd>call codeium#CycleCompletions(1)<CR>
imap <leader>] <Cmd>call codeium#CycleCompletions(1)<CR>
" inoremap <C-'> <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <leader>[ <Cmd>call codeium#CycleCompletions(-1)<CR>
inoremap <C-b> <Cmd>call codeium#Clear()<CR>

" ----------------
" Enable mouse 
" ----------------
set mouse=a

" ----------------
" Default Windows config
" ----------------
" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction
