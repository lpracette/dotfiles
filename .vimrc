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
Plug 'chriskempson/base16-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'          " nice status bar
Plug 'vim-airline/vim-airline-themes'   " nice status bar colors
Plug 'nathanaelkane/vim-indent-guides'  " toggle: \-ig
Plug 'kshenoy/vim-signature'            " show marks beside line no
Plug 'tpope/vim-fugitive'               " git plugin
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'christoomey/vim-tmux-navigator'   " navigate seamlessly between vim and tmux splits
Plug 'majutsushi/tagbar'                " Code navigation
Plug 'python-mode/python-mode'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fuzy seach
Plug 'junegunn/fzf.vim'                                           " key bindings
Plug 'scrooloose/nerdtree',                                       " File explorer
Plug 'Xuyuanp/nerdtree-git-plugin',                               " git status symbole in NERDTree
Plug 'ryanoasis/vim-devicons'
Plug 'vim-scripts/DrawIt'                                         " draw boxes and arrows
Plug 'nathanalderson/yang.vim'

function! BuildYCM(info)
    if a:info.status == 'installed' || a:info.force
        !./install.py --clang-completer --js-completer
    endif
endfunction

function! BuildCC(info)
    if a:info.status == 'installed' || a:info.force
        !mkdir build
        !cd build && cmake ..
        !cd build && make && make install
        !cd build && make clean && make clean_clang
    endif
endfunction


Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp'], 'do': function('BuildYCM') }
Plug 'jeaye/color_coded', { 'for': ['c', 'cpp'], 'do': function('BuildCC') }
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

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
inoremap jk <esc> 

" Identation
set expandtab
set tabstop=4
set shiftwidth=4
set cindent
set autoindent
filetype indent on
autocmd FileType make set noexpandtab
autocmd BufRead,BufNewFile   *.html,*.php,*.yaml setl sw=2 sts=2 et foldmethod=indent
autocmd BufRead,BufNewFile   *.c,*.cpp,*.h setl sw=4 sts=4 et

" color theme
syntax enable
set background=dark
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
else
    colorscheme desert
endif

if &term =~ '256color'
    " disable Background Color Erase (BCE)
    set t_ut=
endif

" Indicates a fast terminal connection.  More characters will be sent to the
" screen for redrawing
set ttyfast

" End-of-line options
set fileformats=unix,dos

" struct member autocomple, c only, if YCM is not used
set omnifunc=ccomplete#Complete

" Show more information while completing tags.
set showfulltag

" Always show status line
set laststatus=2

" mode is shown in the status line
set noshowmode

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

"  highlight the current line in every window and update the highlight as the
"  cursor moves.
set cursorline

" Let cursor move past the last char in <C-v> mode
set virtualedit=block

" Keep 10 lines above and below the cursor
set scrolloff=10

" Gvim options
if has("gui_running")
    set go=
    colorscheme solarized
    set mouse=a
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


" ====================================
" Key Maps
" ====================================
"cscope config
if has('cscope')
    set cscopetag

    if has('quickfix')
        set cscopequickfix=s-,c-,d-,i-,t-,e-
    endif

    if filereadable("cscope.out")
        try
            cs add cscope.out
        catch /^Vim\%((\a\+)\)\=:E568/
        endtry
    endif

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif

" Toggle line numbers and special characters with <F3>
noremap <F3> :set nu!<CR>
inoremap <F3> <C-o>:set nu!<CR>

" Toggle paste mode
set pastetoggle=<F2>

" switch back to last buffer
cmap bb b#

    

" ====================================
" Plugin Configuration
" ====================================

" python-mode
" -----------
let g:pymode_options_max_line_length=120
autocmd FileType python set colorcolumn=120
 

" vim-airline
" ------------
"  " don't count trailing whitespace since it lags in huge files
"let g:airline#extensions#whitespace#enabled = 0
 " put a buffer list at the top
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
let g:airline#extensions#tabline#buffer_nr_show = 1

"special characters
let DISABLE_POWERLINE_FONT=$DISABLE_POWERLINE_FONT 
if DISABLE_POWERLINE_FONT == '1' 
    " use when a powerline font is not installed, define empty  powerline symbols
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
else
    let g:airline_powerline_fonts = 1 " needs https://github.com/powerline/fonts
endif


" NERDTree
" ------------
"autocmd VimEnter * NERDTreeFind
"autocmd VimEnter * wincmd p
augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
                \  if isdirectory(expand('<amatch>'))
                \|   call plug#load('nerdtree')
                \|   execute 'autocmd! nerd_loader'
                \| endif
augroup END
nnoremap <silent> <Leader>v :NERDTreeFind<CR>
let NERDTreeShowHidden=1


" Tagbar
" ------------
"autocmd VimEnter * nested :call tagbar#autoopen(1)


" fzf
" ------------
" git grep
command! -bang -nargs=* GGrep
      \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

" Augmenting Ag command using fzf#vim#with_preview function
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
noremap <leader>e :Files<CR>


" YCM
" -----------
let g:ycm_confirm_extra_conf = 0


" ====================================
" Funcitons
" ====================================
function! GetVisualSelection() " from http://stackoverflow.com/a/6271254
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ?  1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endfunction

function! EncodeUrl(url) " Add characters as needed
    let l:encoded=substitute(a:url,     " ",  "\\\\%20", "g") " Space
    let l:encoded=substitute(l:encoded, "&",  "\\\\%26", "g") " Ampersand 
    let l:encoded=substitute(l:encoded, "+",  "\\\\%2B", "g") " Plus 
    let l:encoded=substitute(l:encoded, ",",  "\\\\%2C", "g") " Comma 
    let l:encoded=substitute(l:encoded, "/",  "\\\\%2F", "g") " Forward slash/Virgule 
    let l:encoded=substitute(l:encoded, ":",  "\\\\%3A", "g") " Colon 
    let l:encoded=substitute(l:encoded, ";",  "\\\\%3B", "g") " Semi-colon 
    let l:encoded=substitute(l:encoded, "=",  "\\\\%3D", "g") " Equals 
    let l:encoded=substitute(l:encoded, "?",  "\\\\%3F", "g") " Question mark 
    let l:encoded=substitute(l:encoded, "@",  "\\\\%40", "g") " 'At' symbol 
    let l:encoded=substitute(l:encoded, "?",  "\\\\%22", "g") " Quotation marks
    let l:encoded=substitute(l:encoded, "<",  "\\\\%3C", "g") " 'Less Than' symbol
    let l:encoded=substitute(l:encoded, ">",  "\\\\%3E", "g") " 'Greater Than' symbol
    let l:encoded=substitute(l:encoded, "{",  "\\\\%7B", "g") " Left Curly Brace 
    let l:encoded=substitute(l:encoded, "}",  "\\\\%7D", "g") " Right Curly Brace 
    let l:encoded=substitute(l:encoded, "|",  "\\\\%7C", "g") " Vertical Bar/Pipe 
    let l:encoded=substitute(l:encoded, "~",  "\\\\%7E", "g") " Tilde 
    let l:encoded=substitute(l:encoded, "[",  "\\\\%5B", "g") " Left Square Bracket 
    let l:encoded=substitute(l:encoded, "]",  "\\\\%5D", "g") " Right Square Bracket 
    let l:encoded=substitute(l:encoded, "`",  "\\\\%60", "g") " Grave Accent 
    let l:encoded=substitute(l:encoded, "#",  "\\\\%23", "g") " 'Pound' character
    " let l:encoded=substitute(a:url, %,  \\\\%25, g)     " Percent character
    " let l:encoded=substitute(l:encoded, \\, \\\\%5C, g) " Backslash 
    " let l:encoded=substitute(l:encoded, $,  \\\\%24, g) " Dollar 
    " let l:encoded=substitute(l:encoded, ^,  \\\\%5E, g) " Caret 
    return encoded
endfunction

function! SearchGoogleW3m(str,extra)
    let l:sCmd="w3m -M www.google.com/search\\?q=".EncodeUrl(a:str).a:extra
    "echom l:sCmd
    execute "!" . l:sCmd
endfunction

vnoremap <leader>g :call SearchGoogleW3m(GetVisualSelection(), "")<CR>


" https://stackoverflow.com/a/26314537
let g:rnd = localtime() % 0x10000
function! Random(n) abort
  let g:rnd = (g:rnd * 31421 + 6927) % 0x10000
  return g:rnd * a:n / 0x10000
endfunction


if !empty(glob("~/.vim/plugged/tagbar/plugin/tagbar.vim"))
    noremap <leader>t :make TEST=<C-R>=substitute(tagbar#currenttag("%s",""),"()","","")<CR><CR>
else
    echom "Using <cword> for <leader>t"
    noremap <leader>t :make TEST=<C-R>=expand("<cword>")<CR><CR>
endif


