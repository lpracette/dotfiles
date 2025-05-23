
" Plugin Management with vim-plug
call plug#begin()  " Begin section for defining plugins


Plug 'dstein64/vim-startuptime'  " A Vim plugin to profile Vim's startup tim
" Appearance plugins
Plug 'kshenoy/vim-signature'  " Plugin to toggle, display and navigate marks
Plug 'pedrohdz/vim-yaml-folds'  " YAML, RAML, EYAML & SaltStack SLS folding for Vim
Plug 'arecarn/vim-clean-fold'  " Provides cleaning function for folds

" Git plugins
Plug 'tpope/vim-fugitive'  " A Git wrapper
Plug 'shumphrey/fugitive-gitlab.vim'  " Fugitive GBrowse for GitLab
Plug 'tpope/vim-rhubarb'  " Fugitive GBrowse for GitHub
Plug 'airblade/vim-gitgutter'  " A Vim plugin which shows a git diff in the sign column

" LSP plugin
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Make your Vim/Neovim as smart as VSCode

" Golang plugin
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go'}  " Go development plugin for Vim

" Neovim specific plugins
if has('nvim')  " Check if Neovim is being used
    Plug 'Mofiqul/vscode.nvim'  " VSCode theme for Neovim
    Plug 'nvim-lualine/lualine.nvim'  " A blazing fast and easy to configure neovim statusline plugin
    Plug 'akinsho/bufferline.nvim'  " A snazzy bufferline for Neovim
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Nvim Treesitter configurations and abstraction layer
    Plug 'nvim-tree/nvim-web-devicons'  " A lua fork of vim-devicons
    Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown' }  " Markdown preview plugin for (Neo)vim
    Plug 'nvim-tree/nvim-tree.lua'  " A File Explorer For Neovim
    Plug 'lukas-reineke/indent-blankline.nvim'  " This plugin adds indentation guides to all lines
    " Plug 'mfussenegger/nvim-dap'  " Debug Adapter Protocol client implementation for Neovim
    " Plug 'rcarriga/nvim-dap-ui'  " A UI for nvim-dap
    " Plug 'leoluz/nvim-dap-go'  " An extension for nvim-dap providing configurations for launching go debugger (delve) and debugging individual tests
    " Plug 'github/copilot.vim'  " GitHub Copilot for Vim
    " Plug 'jonahgoldwastaken/copilot-status.nvim', { 'branch': 'main' } " Simple Copilot status indicator for Neovim
    Plug 'zbirenbaum/copilot.lua'  " A Neovim plugin for GitHub Copilot
    Plug 'nvim-lua/plenary.nvim'
    Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'main'}
    Plug 'AndreM222/copilot-lualine'
else
    Plug 'tomasiser/vim-code-dark'  " Dark color scheme for Vim
    Plug 'vim-airline/vim-airline'  " Lean & mean status/tabline for vim that's light as air
    Plug 'vim-airline/vim-airline-themes'  " A collection of themes for vim-airline
    Plug 'sheerun/vim-polyglot'  " A collection of language packs for Vim
    Plug 'ryanoasis/vim-devicons'  " Adds file type glyphs/icons to popular Vim plugins: NERDTree, vim-airline
    Plug 'puremourning/vimspector'  " A multi language graphical debugger for Vim
    Plug 'scrooloose/nerdtree'  " File explorer
    Plug 'johnstef99/vim-nerdtree-syntax-highlight'  " Syntax highlighting for NERDTree
    Plug 'Xuyuanp/nerdtree-git-plugin'  " A plugin of NERDTree showing git status
endif

" Fuzzy search plugins
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }  " A command-line fuzzy finder
Plug 'junegunn/fzf.vim'  " Fuzzy finder for Vim
Plug 'Avi-D-coder/fzf-wordnet.vim'  " Dictionary completion powered by FZF and Wordnet for vim and your terminal
Plug 'nvim-lua/plenary.nvim'  " All the lua functions I don't want to write twice
Plug 'nvim-telescope/telescope.nvim'  " A highly extendable fuzzy finder over lists
Plug 'fannheyward/telescope-coc.nvim'  " coc.nvim integration for telescope.nvim

" Keybinding plugins
Plug 'tpope/vim-commentary'  " Comment stuff out, Use gcc to comment out a line
Plug 'christoomey/vim-tmux-navigator'  " Seamless navigation between tmux panes and vim splits
Plug 'RyanMillerC/better-vim-tmux-resizer'  " Better resizing of panes for Tmux and Vim
Plug 'vim-utils/vim-husk'  " Mappings that boost vim command line mode
Plug 'tpope/vim-surround'  " Quoting/parenthesizing made simple
Plug 'tpope/vim-repeat'  " Enable repeating supported plugin maps with '.'
Plug 'tpope/vim-abolish'  " Easily search for, substitute, and abbreviate multiple variants of a word
Plug 'junegunn/vim-easy-align'  " A Vim alignment plugin
" Plug 'Kachyz/vim-gitmoji'

" Plug 'marko-cerovac/material.nvim'
" Plug 'sainnhe/edge'
" Plug 'mhartington/oceanic-next'
" Plug 'catppuccin/nvim', { 'as': 'catppuccin' } " 🍨 Soothing pastel theme for (Neo)vim
" Plug 'tomasiser/vim-code-dark'  " Dark color scheme for Vim



call plug#end()  " End section for defining plugins

" Basic vim configuration
set nu  " Display line numbers
set nowrap  " Do not wrap lines
set hlsearch  " Highlight search results
set incsearch  " Incremental search
set expandtab  " Use spaces instead of tabs
set tabstop=4  " Number of spaces a tab counts for
set shiftwidth=4  " Number of spaces used for each step of (auto)indent
set cindent  " C-style indentation
set autoindent  " Copy indent from current line when starting a new line
filetype indent on  " Enable filetype-based indentation
set backspace=indent,eol,start  " Allow backspacing over everything in insert mode
autocmd FileType make set noexpandtab  " Do not expand tabs in Makefiles

" Spellcheck commit messages and markdown
augroup Spellcheck
    autocmd!
    autocmd BufRead,BufNewFile *.md setlocal spell spelllang=en_us  " Enable spell check for markdown files
    autocmd FileType gitcommit setlocal spell spelllang=en_us  " Enable spell check for git commit messages
    autocmd FileType yaml setlocal spell spelllang=en_us  " Enable spell check for git commit messages
augroup END

" Add #! to new scripts
augroup Shebang
    autocmd!
    autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python\<nl>\<nl>\"|$  " Add python shebang to new .py files
    autocmd BufNewFile *.sh 0put =\"#!/usr/bin/env bash\<nl>\<nl>\"|$  " Add bash shebang to new .sh files
augroup END

" Color theme
syntax enable  " Enable syntax highlighting
function! SetBackgroundBasedOnSystemTheme()
    if has("mac")
        try
            let s:mode = systemlist("osascript -e 'tell app \"System Events\" to tell appearance preferences to return dark mode'")[0]
            if s:mode ==# "true"
                set background=dark  " Set background to dark if system theme is dark
            else
                set background=light  " Set background to light if system theme is light
            endif
        catch
            set background=dark  " Set background to dark if osascript is not available or fails
        endtry
    else
        set background=dark  " Set background to dark if not on macOS
    endif
endfunction

" Run the function after Vim has started
autocmd VimEnter * call SetBackgroundBasedOnSystemTheme()
if has('termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"  " Enable true color support
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"  " Enable true color support
  set termguicolors  " Enable true color support
endif

if has('nvim')
lua <<EOF
require('vscode').setup({
     -- Enable transparent background
    transparent = true,

    -- Enable italic comment
    italic_comments = true,

    -- Underline `@markup.link.*` variants
    underline_links = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,
})
require('vscode').load()


require('bufferline').setup({
    options = {
        numbers = "buffer_id",
        separator_style = "thick", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
        offsets = {
            { filetype = "nerdtree", text = "File Explorer", },
            { filetype = "NvimTree", text = "File Explorer", }, },
    },
})



require('copilot').setup({
    panel = {
        keymap = {
            accept = "<C-E>",
        },
    },
    suggestion = {
        auto_trigger = true,
        keymap = {
            accept = "<C-E>",
        },
    },
    filetypes = {
        markdown = true,
        yaml = true
    },
})
vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#808080" })


require('lualine').setup({
    options = {
        theme = 'vscode',
        disabled_filetypes = {'nerdtree','NvimTree'},
    },
    sections = {
        lualine_x = { 'copilot' ,'encoding', 'fileformat', 'filetype' }, -- I added copilot here
    }
})

-- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
require("nvim-tree").setup()

require("ibl").setup()
 
require("CopilotChat").setup {
  debug = false, -- Enable debugging
  -- See Configuration section for rest
}
EOF


autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && &filetype !=# 'man' | NvimTreeOpen | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in')   | execute 'NvimTreeOpen' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif


else
let g:codedark_italics=1
let g:codedark_transparent=1
let g:airline_theme = 'codedark'
colorscheme codedark
endif

"if exists('$BASE16_THEME') && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
"    let base16colorspace=256 " https://github.com/chriskempson/base16-vim#256-colorspace
"    colorscheme base16-$BASE16_THEME
"endif

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
set foldmethod=indent
set foldlevelstart=99
let g:markdown_folding = 1

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

" set cursorline " Highlight the text line of the cursor
"set relativenumber " Show the line number relative to the line with the cursor in front of each line.

" Let cursor move past the last char in <C-v> mode
set virtualedit=block

" Keep 10 lines above and below the cursor
set scrolloff=10

" Mouse all
set mouse=a

" Gvim options
if has("gui_running")
    try
        set guifont=RobotoMonoNFM-Rg:h13

    catch /^Vim\%((\a\+)\)\=:E596/
        echom "The RobotoMonoNFM-Rg Nerd Font is not installed"
    endtry
endif

" To disable beeping
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

" ====================================
" Plugin Configuration
" ====================================

" vim-airline
" ------------
if !has('nvim')
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
let NERDTreeShowHidden=1
let g:NERDTreeStatusline = '%#NonText#'
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:NERDTreeMapJumpPrevSibling=""
let g:NERDTreeMapJumpNextSibling=""

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in')   | execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && &filetype !=# 'man' | NERDTree | endif


" vimspector
" ------------
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
let g:vimspector_install_gadgets = [ 'vscode-node-debug2' ]

endif

" coc, see https://github.com/neoclide/coc.nvim#example-vim-configuration
" ------------
"  coc will install the missing extensions after coc.nvim service started
let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-eslint', 'coc-vimlsp', 'coc-yaml', 'coc-prettier', 'coc-webview', 'coc-swagger','coc-go', 'coc-pyright']

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')

" vim-markdown-preview
"---------
let vim_markdown_preview_github=1
let vim_markdown_preview_browser='Google Chrome'

let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'mermaid', 'json', 'yaml']
let g:markdown_syntax_conceal = 0


" vim-surround
"---------
autocmd FileType markdown let b:surround_{char2nr('i')} = "*\r*"
autocmd FileType markdown let b:surround_{char2nr('b')} = "**\r**"

" nvim-treesitter
"---------
if has('nvim')
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,
    -- disable = {"markdown"},
  },
  additional_vim_regex_highlighting = false,
}

require'nvim-web-devicons'.setup({})

-- require('dapui').setup()
-- require('dap-go').setup()
EOF
endif

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

" gf creates file if it does not exists, use gF to open only
noremap gf :e <cfile><cr>

" insert current date-time
nnoremap <silent> <leader>i  "=strftime("%c")<CR>P
nnoremap <silent> <leader>ic  "=printf(&commentstring, strftime(" %c "))<CR>P

" add a markdown h3 with date
autocmd FileType markdown  nnoremap <silent> <leader>an  "=printf("###%s (%s)\n", input("Note title: "),strftime("%c"))<CR>P

" add a markdown entry for daily scrum
autocmd FileType markdown  nnoremap <silent> <leader>de  "=printf("\n### (%s)\n#### Done\n - \n#### Problems\n \n#### Todo\n - \n", strftime("%c"))<CR>PjjjA

" Open current file in vscode
noremap <silent> <leader>v :call system('code ' . getcwd() . ' --goto ' .expand('%') . ':' . line('.')  . ':' . col('.'))<CR>

" Convert JSON to YAML/ YAML to JSON with python3
xnoremap <silent> <leader>ty :'<,'>!python3 -c 'import sys, json, yaml; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'<CR>
xnoremap <silent> <leader>tj :'<,'>!python3 -c 'import sys, json, yaml;print(json.dumps(yaml.load(sys.stdin,Loader=yaml.FullLoader), indent=2,default=str))'<CR>

" Open link, use fugitive's GBrowse 
xnoremap <silent> <leader>c y<Esc>:GBrowse <C-R>"<CR>
nnoremap <silent> <leader>c :execute 'GBrowse '.expand('<cWORD>')<CR>

" Search in google, use fugitive's GBrowse
xnoremap <silent> <leader>s y<Esc>:GBrowse https://www.google.com/search?q=<C-R>"<CR>
nnoremap <silent> <leader>s :execute 'GBrowse https://www.google.com/search?q='.expand('<cWORD>')<CR>

" copilot
" ------------

" imap <silent><script><expr> <C-E> copilot#Accept("\<CR>")
" let g:copilot_no_tab_map = v:true
" let g:copilot_workspace_folders = ['~/go', './internal','~/copilot_context']


" fzf.vim
" ------------
" see https://github.com/junegunn/fzf.vim#commands
" nnoremap <silent> <leader>g :vimgrep /<C-R><C-W>/ **/*.* \| cw<CR>
" " nnoremap          <leader>g  :execute '<C-u>Rg '.expand('<cWORD>')<CR>
" xnoremap          <leader>g  y<Esc>:Rg <C-R>"
" nnoremap <silent> <leader>e  :Files<CR>
" nnoremap <silent> <leader>b  :Buffers<CR>
" nnoremap <silent> <leader>h  :History<CR>

nnoremap <silent> <leader>g :vimgrep /<C-R><C-W>/ **/*.* \| cw<CR>
xnoremap          <leader>g  y<Esc>:Rg <C-R>"
nnoremap <silent> <leader>e  :Files<CR>
nnoremap <silent> <leader>b  :Buffers<CR>
 

function! FzfSpellSink(word)
  exe 'normal! "_ciw'.a:word
endfunction
function! Gitmoji()
    let suggestions = emoji#list()
  if executable('wn')
      return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': '30%', 'options': ['--preview', 'wn {} -over']})
  else
      return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': '30%'})
  endif
endfunction
nnoremap <silent> <leader>x :call Gitmoji()<CR>

 
" " Spell suggestions: https://coreyja.com/vim-spelling-suggestions-fzf/  
" function! FzfSpellSink(word)
"   exe 'normal! "_ciw'.a:word
" endfunction
" function! FzfSpell()
"   let suggestions = spellsuggest(expand("<cword>"))
"   if executable('wn') h
"       return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': '30%', 'options': ['--preview', 'wn {} -over']})
"   else
"       return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': '30%'})
"   endif
" endfunction
" nnoremap <silent> <leader>z :call FzfSpell()<CR>
nnoremap <silent> <leader>z :Telescope spell_suggest<CR>


" go-vim
" ------------
let g:go_def_mapping_enabled = 0

" coc.vim
" ------------
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm(): "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

nmap <leader>% :let @*=expand('%:p')<CR>


" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" coc-fzf
" nmap <leader>o :CocFzfList outline<CR>
" nmap <leader>l :CocFzfList<CR>

" coc-swagger
" ------------
autocmd FileType yaml  nnoremap <buffer> <leader>p :CocCommand swagger.render<CR>


" tpope/vim-commentary
" ------------
autocmd FileType rego setlocal commentstring=#\ %s

if has('nvim')
    " nmap <leader>dd lua require("dapui").toggle()

    " coc-markdown-preview-enhanced
    " ------------
    autocmd FileType markdown  nnoremap <buffer> <leader>p <Plug>MarkdownPreview
    let g:mkdp_theme = 'light'


    " NERDTree
    " ------------
    nnoremap <silent> - :NvimTreeFindFileToggle<CR>
else
    " vimspector
    " ------------
    nmap <leader>ds <Plug>VimspectorStepOver
    nmap <leader>di <Plug>VimspectorStepInto
    nmap <leader>dd <Plug>VimspectorBalloonEval
    xmap <leader>dd <Plug>VimspectorBalloonEval

    " NERDTree
    " ------------
    " nnoremap <silent> - :NERDTreeFind<CR>
    nnoremap <silent> <expr> - g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
endif


" CopilotChat
" ------------
" nnoremap <leader>cc  :CopilotChat 
" nnoremap <leader>ccb :CopilotChatBuffer
" nnoremap <leader>cce <cmd>CopilotChatExplain<cr>
" nnoremap <leader>cct <cmd>CopilotChatTests<cr>
" xnoremap <leader>ccv :CopilotChatVisual<cr>
" xnoremap <leader>ccx :CopilotChatInPlace<cr>

function! QuickChat()
  let input = input("Quick Chat: ")
  if input != ""
    call luaeval('require("CopilotChat").ask(_A.input, { selection = require("CopilotChat.select").buffer })', {'input': input})
  endif
endfunction

nnoremap <silent> <leader>cc :CopilotChatToggle<CR>
nnoremap <leader>ccd :CopilotChatDocs<CR>
nnoremap <leader>cct :CopilotChatTests<CR>
nnoremap <leader>ccr :CopilotChatReview<CR>
nnoremap <leader>ccb :call QuickChat()<CR>



" fzf-wordnet.vim
" ------------
imap <C-S> <Plug>(fzf-complete-wordnet)


" junegunn/vim-easy-align
" -----------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

source ~/.vimrc.local


