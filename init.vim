call plug#begin('~/.vim/plugged')

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Completion framework
Plug 'hrsh7th/nvim-cmp'

" LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'

" Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'

" Other usefull completion sources
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'

" See hrsh7th's other plugins for more completion sources!

" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'simrat39/rust-tools.nvim'

" Snippet engine
Plug 'hrsh7th/vim-vsnip'

" Fuzzy finder
" Optional
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Color scheme used in the GIFs!
" Plug 'arcticicestudio/nord-vim'

Plug 'preservim/nerdtree'

Plug 'fatih/molokai'
" Plug 'gilgigilgil/anderson.vim'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'doums/darcula'

Plug 'airblade/vim-gitgutter'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-fugitive'

Plug 'fatih/vim-go'
" Plug 'ray-x/go.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }

call plug#end()
"====================================================================================================================
" Some basic stuff

" colorscheme molokai
" colorscheme sonokai
colorscheme darcula

" show lines numbers
" set number

" use relative numbers for lines
set number relativenumber

" use system clipboard
set clipboard=unnamedplus

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

" git branch in statusline
" function! StatuslineGit()
"   let l:branchname = GitBranch()
"   return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
" endfunction
" set statusline=
" set statusline+=%{StatuslineGit()}
"====================================================================================================================

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
      --  autoSetHints = true,
      --  hover_with_actions = true,
      --  inlay_hints = {
      --      show_parameter_hints = false,
      --      parameter_hints_prefix = "",
      --      other_hints_prefix = "",
      --  },
        inlay_hints = {
            auto = false, 
        }
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)

-- require('go').setup()

EOF
"====================================================================================================================

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF


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
let g:go_auto_type_info = 1
let g:vim_markdown_folding_disabled = 1
autocmd FileType go nmap gi  <Plug>(go-implements)
autocmd FileType go nnoremap  gr :GoReferrers<CR>
autocmd FileType go nnoremap  gn :GoRename<CR>
nnoremap <F3> :GoDebugTest<CR>
nnoremap <F4> :GoDebugBreakpoint<CR>
nnoremap <F5> :GoDebugStep<CR>
nnoremap <F6> :GoDebugStepOut<CR>
nnoremap <F7> :GoDebugContinue<CR>
nnoremap <F8> :GoDebugNext<CR>
nnoremap <F9> :GoDebugRestart<CR>
"====================================================================================================================
