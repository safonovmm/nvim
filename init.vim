call plug#begin('~/.vim/plugged')

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Fuzzy finder
" Optional
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'preservim/nerdtree'

Plug 'doums/darcula'

Plug 'airblade/vim-gitgutter'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-fugitive'

Plug 'fatih/vim-go'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'rmagatti/auto-session'

call plug#end()
"====================================================================================================================
" Some basic stuff
colorscheme darcula

" use relative numbers for lines
set number relativenumber

" use system clipboard
set clipboard=unnamedplus
let g:clipboard = {
          \   'name': 'win32yank-wsl',
          \   'copy': {
          \      '+': 'win32yank.exe -i --crlf',
          \      '*': 'win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o --lf',
          \      '*': 'win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 0,
          \ }

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" boundry column for line length
set colorcolumn=80

" highlight cursor line
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#303000 ctermbg=234

" highlight in file the word to which the cursor is pointin
autocmd CursorMoved * exe printf('match TabLineSel /\V\<%s\>/', escape(expand('<cword>'), '/\'))

" disable search highlight
set nohlsearch

set tabstop=4
set shiftwidth=4
set expandtab

set ignorecase
set smartcase

"====================================================================================================================
" Stuff from https://sharksforarms.dev/posts/neovim-rust/
" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
" rename variable
nnoremap <silent> gn    <cmd>lua vim.lsp.buf.rename()<CR>
" code actions
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>
" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes
" forman on write
autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 200)
"====================================================================================================================

" nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" autocmd bufenter * if (winnr("$") == 1 && bufname('%') =~ 'NERD_tree_') | q | endif
let g:NERDTreeWinSize=30
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" fix for working properly with auto-sessions plugin 
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && !filereadable(expand('~/.vim/auto-sessions/'. getcwd() .'.vim')) | NERDTree | endif
"====================================================================================================================
" Telescope

" Find files using Telescope command-line sugar.
nnoremap <silent>ff <cmd>Telescope find_files<CR>
nnoremap <silent>fg <cmd>Telescope live_grep<CR>
nnoremap <silent>fb <cmd>Telescope buffers<CR>
nnoremap <silent>fh <cmd>Telescope help_tags<CR>

" Using Lua functions
"nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
"nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<CR>
"nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<CR>
"nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<CR>
"====================================================================================================================
" Airline

let g:airline_theme='minimalist'
"====================================================================================================================
"vim-go

let g:go_fmt_command = "goimports"
" let g:go_auto_type_info = 1
let g:vim_markdown_folding_disabled = 1
autocmd FileType go nmap gi  <Plug>(go-implements)
autocmd FileType go nnoremap  gr :GoReferrers<CR>
autocmd FileType go nnoremap  gn :GoRename<CR>
autocmd FileType go nnoremap  gs :GoFillStruct<CR>
autocmd FileType go nnoremap  gc :GoDoc<CR>
autocmd FileType go nnoremap  ge :GoErrCheck<CR>
autocmd FileType go nnoremap  gf :GoIfErr<CR>
autocmd FileType go nnoremap  gx :GoExtract<CR>

nnoremap <F3> :GoDebugTest<CR>
nnoremap <F4> :GoDebugBreakpoint<CR>
nnoremap <F5> :GoDebugStep<CR>
nnoremap <F6> :GoDebugStepOut<CR>
nnoremap <F7> :GoDebugContinue<CR>
nnoremap <F8> :GoDebugNext<CR>
nnoremap <F9> :GoDebugRestart<CR>

let g:go_highlight_function_calls = 1
"====================================================================================================================
" Use coc.nvim for autocompletion
let g:coc_global_extensions = ['coc-go']

" Set up Go language server for coc.nvim
autocmd FileType go let g:coc_server_prog = 'gopls'

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Disable errors highlighting
let b:coc_diagnostic_disable=1
" Set gray color for autocompletion highlighting
highlight CocSearch ctermfg=250 guifg=#bcbcbc

"====================================================================================================================
" auto-session
" let g:auto_session_enabled = 1
" let g:auto_session_root_dir = 
" let g:auto_session_enable_last_session = 0

lua << EOF
local opts = {
  log_level = 'info',
  auto_session_enable_last_session = false,
  auto_session_root_dir = "~/.vim/auto-sessions/",
  auto_session_enabled = true,
  auto_save_enabled = nil,
  auto_restore_enabled = false,
  auto_session_suppress_dirs = nil,
  auto_session_use_git_branch = nil,
  -- the configs below are lua only
  bypass_session_save_file_types = nil
}

require('auto-session').setup(opts)
EOF

"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && !filereadable(expand("~/.vim/auto-sessions/". fnamemodify(getcwd(), ':p:h:t') . '.vim')) | NERDTree | endif
