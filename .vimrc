scriptencoding utf-8
set encoding=utf-8
set nocompatible                   " be iMproved
set runtimepath=~/.vim,$VIMRUNTIME " or else windows uses $HOME/vimfiles

" ====================================
" First time load, install plugins
" ====================================
if empty(glob("~/.vim/autoload/plug.vim"))
    if executable('git')
        execute('!mkdir -p ~/.vim/{autoload,undo,swap} && curl -sfLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim && vim +PlugInstall +qall')
    else
        echom "Please install git to allow plugin configuration through vim-plug"
    endif
endif

" ====================================
" Plugin Management with vim-plug
" ====================================
call plug#begin()


" Navigate and manipulate files in a tree view.
Plug 'scrooloose/nerdtree',            " File explorer
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Appearance: colors, status bar, icons
Plug 'chriskempson/base16-vim'          "
Plug 'vim-airline/vim-airline'          " lean & mean status/tabline for vim that's light as air
Plug 'vim-airline/vim-airline-themes'   " A collection of themes for vim-airline
Plug 'kshenoy/vim-signature'            " Plugin to toggle, display and navigate marks
Plug 'ryanoasis/vim-devicons'           " Adds file type glyphs/icons to popular Vim plugins: NERDTree, vim-airline
Plug 'Yggdroot/indentLine'              " A vim plugin to display the indention levels with thin vertical lines
Plug 'junegunn/limelight.vim'           " 🔦 All the world's indeed a stage and we are merely players
Plug 'junegunn/goyo.vim'                " 🌷 Distraction-free writing in Vim
Plug 'junegunn/seoul256.vim'            " 🌳 Low-contrast Vim color scheme based on Seoul Colors
Plug 'pedrohdz/vim-yaml-folds'          " YAML, RAML, EYAML & SaltStack SLS folding for Vim
Plug 'blueyed/vim-diminactive'
Plug 'arecarn/vim-clean-fold'           " Provides cleaning function for folds
Plug 'junegunn/vim-peekaboo'            " 👀 \" / @ / CTRL-R

"
" Coding: tags, git, completion
Plug 'tpope/vim-fugitive'               " a Git wrapper so awesome, it should be illegal
Plug 'shumphrey/fugitive-gitlab.vim'    " fugitive GBrowse for gitlab
Plug 'tpope/vim-rhubarb'                " fugitive GBrowse for github
Plug 'airblade/vim-gitgutter'           " A Vim plugin which shows a git diff in the sign column. 
Plug 'sheerun/vim-polyglot'             " A collection of language packs for Vim
Plug 'liuchengxu/vista.vim'             " View and search LSP symbols, tags in Vim/NeoVim.
Plug 'APZelos/blamer.nvim'              " A git blame plugin for (neo)vim inspired by VS Code's GitLens plugin.
Plug 'puremourning/vimspector'          " A multi language graphical debugger for Vim
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Make your Vim/Neovim as smart as VSCode. requires node `curl -sL install-node.now.sh/lts | bash`

" Fuzy search: buffers, files, tags
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " A command-line fuzzy finder
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }

" Keybinding
Plug 'tpope/vim-repeat'                 " enable repeating supported plugin maps with '.'
Plug 'tpope/vim-commentary'             " comment stuff out, Use gcc to comment out a line
Plug 'christoomey/vim-tmux-navigator'   " Seamless navigation between tmux panes and vim splits
Plug 'vim-utils/vim-husk'               " Mappings that boost vim command line mode.
" Plug 'vim-scripts/DrawIt'               " Ascii drawing plugin: lines, ellipses, arrows, fills, and more!
" Plug 'tpope/vim-surround'               " quoting/parenthesizing made simple
" Plug 'godlygeek/tabular'                " Vim script for text filtering and alignment. http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
" Plug 'AndrewRadev/splitjoin.vim'        " Switch between single-line and multiline forms of code gS / gJ
" Plug 'mbbill/undotree'                  " The undo history visualizer for VIM
" Plug 'arouene/vim-ansible-vault'

" Notes
" Plug 'fmoralesc/vim-pad', {'branch': 'devel'} " a quick notetaking plugin
" Plug 'aaronbieber/vim-quicktask'        " lightweight but feature-rich task management plugin
" Plug 'vim-pandoc/vim-pandoc'            " pandoc integration and utilities for vim
" Plug 'vim-pandoc/vim-pandoc-syntax'     " pandoc markdown syntax, to be installed alongside vim-pandoc

" Plug 'dstein64/vim-startuptime'

call plug#end()


" ====================================
" vim Configuration
" ====================================
" Basic config: line numbers, no line wrap, highlight incremental search,
" remap escape key. Quick config if no .vimrc:
" colo desert |set nu|set nowrap|set hls|set is|inoremap jk <esc>
" With 4 space tabs:
" colo desert |set nu|set et|set ts=4|set sw=4|set ci|set ai|set nowrap|set hls|set is|inoremap jk <esc>
set nu
set nowrap
set hlsearch
set incsearch

" Identation
set expandtab
set tabstop=4
set shiftwidth=4
set cindent
set autoindent
filetype indent on

set backspace=indent,eol,start

autocmd FileType make set noexpandtab
autocmd BufRead,BufNewFile   *.html,*.php,*.yaml,*.json setl sw=2 sts=2 et foldmethod=indent
autocmd BufRead,BufNewFile   *.py setl foldmethod=indent
" autocmd BufRead,BufNewFile   *.c,*.cpp,*.h setl sw=4 sts=4 et

" add #! to new scripts: https://vim.fandom.com/wiki/Shebang_line_automatically_generated
augroup Shebang
  autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python\<nl>\<nl>\"|$
  autocmd BufNewFile *.sh 0put =\"#!/usr/bin/env bash\<nl>\<nl>\"|$
augroup END

" color theme
syntax enable
set background=dark
if filereadable(expand("~/.vimrc_background"))

    function! s:base16_customize() abort
        call Base16hi("Italic",        "", "", "", "", "italic", "")
    endfunction

    augroup on_change_colorschema
        autocmd!
        autocmd ColorScheme * call s:base16_customize()
    augroup END

    let base16colorspace=256
    source ~/.vimrc_background
    " delete 'g:terminal_ansi_colors' from base16 colorscheme, for some reason
    " it removes the colors formt the fzf-preview popup
else
    try
        colorscheme seoul256
        let g:airline_theme='zenburn'
    catch /^Vim\%((\a\+)\)\=:E185/
        colorscheme desert
    endtry
endif

if &term =~ '256color'
    " disable Background Color Erase (BCE)
    set t_ut=
endif

" transparent bg
autocmd vimenter * highlight Normal guibg=NONE ctermbg=NONE
" For Vim<8, replace EndOfBuffer by NonText
autocmd vimenter * highlight EndOfBuffer guibg=NONE ctermbg=NONE

" Indicates a fast terminal connection.  More characters will be sent to the
" screen for redrawing
set ttyfast

" End-of-line options
set fileformats=unix,dos

" " struct member autocomple, c only
" set omnifunc=ccomplete#Complete

" Show more information while completing tags.
set showfulltag

" Add /usr/include tags to the tag search
set tags+=/usr/include/tags

" Always show status line
set laststatus=2

" mode is shown in the status line
set noshowmode

" Shows the number of chars/lines selected in visualmode
set showcmd

" Open splits more naturally
set splitright

" Show invisible chars (eol, tabs, trailing space)
"set list
set listchars=eol:$,tab:▸-,trail:·,extends:↷,precedes:↶,nbsp:•

" Use an undo file and set a directory to store the undo history
set undofile
set undodir=~/.vim/undo/

" put swap files in common dir
set backupdir=~/.vim/swap//,.,/tmp
set directory=~/.vim/swap//,.,/tmp

" automatically create folds, open all folds
set foldmethod=syntax
set foldlevelstart=99

" any buffer can be hidden (keeping its changes) without first writing the
" buffer to a file. This affects all commands and all buffers.
set hidden

" When you type the first tab hit will complete as much as possible, the
" second tab hit will provide a list, the third and subsequent tabs will cycle
" through completion options so you can complete the file without further keys
set wildmode=longest,list,full
set wildmenu

" Configs for vimdiff
if &diff
    set diffopt+=iwhite             " Ignore whitespace in vimdiff
endif

" Run bash interactively with !
" set shellcmdflag="-ic"

"  highlight the current line in every window and update the highlight as the
"  cursor moves.
"set cursorline

" Let cursor move past the last char in <C-v> mode
set virtualedit=block

" Keep 10 lines above and below the cursor
set scrolloff=10

" Mouse all
set mouse=a

" Gvim options
if has("gui_running")
    set go=
    colorscheme solarized
    try
        if has('gui_win32')
            set guifont=DejaVuSansMonoForPowerline_NF:h10:cANSI
        else
            set guifont=Inconsolata-dz\ for\ Powerline\ Medium\ 10
        endif
    catch /^Vim\%((\a\+)\)\=:E596/
        echom "The Inconsolata-dz_for_Powerline font is not installed"
    endtry
endif

" To disable beeping
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

" Spellcheck commit messages
autocmd FileType gitcommit setlocal spell

" ====================================
" Plugin Configuration
" ====================================
"  vim-pad
"  ---------
if empty(glob("~/notes"))
    execute('!mkdir -p ~/notes')
endif
let g:pad#dir = "~/notes"
let g:pad#default_format = "pandoc"


" undotree
" -------
if !exists('g:undotree_WindowLayout')
    let g:undotree_WindowLayout = 2
endif


" vim-airline
" ------------
"  " don't count trailing whitespace since it lags in huge files
"let g:airline#extensions#whitespace#enabled = 0
 " put a buffer list at the top
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#obsession#indicator_text = ''


" NERDTree
" ------------
let g:webdevicons_conceal_nerdtree_brackets = 1

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif


" Vista
" ------------
let g:vista#renderer#enable_icon = 1
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]


" vimspector
" ------------
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
let g:vimspector_install_gadgets = [ 'vscode-node-debug2' ]


" GenTags
" ------------
let g:gen_tags#statusline=1


" coc, see https://github.com/neoclide/coc.nvim#example-vim-configuration
" ------------
"  coc will install the missing extensions after coc.nvim service started
let g:coc_global_extensions = ['coc-json', 'coc-git', "coc-tsserver", "coc-eslint", "coc-vimlsp", "coc-fzf-preview"]

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')


" coc-fzf-preview
" ------------
let g:fzf_preview_use_dev_icons = 1


" indentLine
" -----------
let g:indentLine_char = '┊'
autocmd FileType markdown let g:indentLine_enabled=0


" Limelight
" -----------
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240


" Goyo
" -----------
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowcmd
  set scrolloff=999
  Limelight
  IndentLinesDisable
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showcmd
  set scrolloff=10
  Limelight!
  IndentLinesEnable
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()


" ====================================
" Key Maps
" ====================================
inoremap jk <esc>

" remap leader
let mapleader = "\<Space>"

" Toggle line numbers and special characters with <F3>
noremap <F3> :set nu!<CR>:IndentLinesToggle<CR>:GitGutterToggle<CR>
inoremap <F3> <C-o>:set nu!<CR>:IndentLinesToggle<CR>:GitGutterToggle<CR>

" Toggle paste mode
set pastetoggle=<F2>

" switch back to last buffer
cmap bb b#

" Goyo
nnoremap <leader>o :Goyo 85%<CR>

" Search in google, use fugitive's GBrowse
xnoremap <silent> <leader>s y<Esc>:GBrowse https://www.google.com/search?q=<C-R>"<CR>

" coc-fzf-preview
" ------------
nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]
nnoremap <silent> [fzf-p]p     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>
nnoremap          <leader>g  :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
nnoremap <silent> <leader>gg :<C-u>CocCommand fzf-preview.ProjectGrepRecall<CR>
nnoremap <silent> <leader>e  :CocCommand fzf-preview.DirectoryFiles<CR>
nnoremap <silent> <leader>b  :CocCommand fzf-preview.AllBuffers<CR>

" coc.vim
" ------------
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr :<C-u>CocCommand fzf-preview.CocReferences<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>ff <Plug>(coc-format-selected)
nmap <leader>ff <Plug>(coc-format-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" vimspector
" ------------
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
let g:vimspector_install_gadgets = [ 'vscode-node-debug2' ]
nmap <leader>ds <Plug>VimspectorStepOver
nmap <leader>di <Plug>VimspectorStepInto
nmap <leader>dd <Plug>VimspectorBalloonEval
xmap <leader>dd <Plug>VimspectorBalloonEval

" NERDTree
" ------------
nnoremap <silent> - :NERDTreeFind<CR>

" Vista
" ------------
nmap <silent> <leader>t :<C-u>Vista finder<CR>
