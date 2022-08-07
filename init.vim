" Options
set cursorline
set autoindent
set number
set title
set wildmenu
set laststatus=2

" Plugin management with PlugInstall
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'NLKNguyen/papercolor-theme',

" Language Server shenanigans
Plug 'neovim/nvim-lspconfig',
Plug 'hrsh7th/cmp-nvim-lsp',
Plug 'hrsh7th/cmp-buffer',
Plug 'hrsh7th/cmp-path',
Plug 'hrsh7th/cmp-cmdline',
Plug 'hrsh7th/nvim-cmp',

" vsnip for snippets
Plug 'hrsh7th/cmp-vsnip',
Plug 'hrsh7th/vim-vsnip',

" Tree-sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Status line
Plug 'hoob3rt/lualine.nvim'

call plug#end()


" Color scheme
colorscheme PaperColor

" Enable autocompletion
set wildmode=longest,list,full

lua <<EOF

	-- Setup nvim-cmp
	local cmp = require'cmp'

	cmp.setup({
		snippet = {
		-- Specification of snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
		},

		mapping = {
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        	['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        	['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        	['<C-y>'] = cmp.config.disable,
        	['<C-e>'] = cmp.mapping({
            		i = cmp.mapping.abort(),
            		c = cmp.mapping.close(),
        	}),
        	['<CR>'] = cmp.mapping.confirm({ select = true }),
		},

		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' },
			{ name = 'buffer' },
		}),
	})

	-- Use buffer source for `/`
	cmp.setup.cmdline('/', {
		sources = {
			{ name = 'buffer' }
		}
	})

	-- Use cmdline & path source for ':'
	cmp.setup.cmdline(':', {
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		})
	})

EOF

" LSP Setup
lua << EOF

	-- Setup lspconfig
	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	-- Put in all of the enabled lsp servers
	require('lspconfig')["fortls"].setup {
		capabilities = capabilities
	}
	require('lspconfig')['pyright'].setup {
		capabilities = capabilities
	}
	require('lspconfig')['clangd'].setup {
		capabilities = capabilities
	}
	require('lspconfig')['hls'].setup {
		capabilities = capabilities
	}

EOF

" Treesitter setup
lua << EOF
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		disable = {},
	},
	indent = {
		enable = false,
		disable = {},
	},
	ensure_installed = {
		"c",
		"cmake",
		"cpp",
		"julia",
		"llvm",
		"lua",
		"make",
		"ninja",
		"python"
	},
}
EOF

" Telescope setup
lua << EOF

	local actions = require('telescope.actions')

	require('telescope').setup {
		defaults = {
			mappings = {
				n = {
					["q"] = actions.close
				},
			},
		}
	}

EOF

" Status line setup
lua << EOF

	local status, lualine = pcall(require, "lualine")
	if (not status) then return end

	require('lualine').setup {
		options = {
			icons_enabled = true,
			section_separators = {'[]', '[]'},
			component_separators = {'[]', '[]'},
			disabled_filetypes = {}
		},
		sections = {
			lualine_a = {'mode'},
			lualine_b = {'branch'},
			lualine_c = {'filename'},
			lualine_x = {
				{ 'diagnostics', sources = {"nvim_lsp"}, symbols = {error = '[]', warn = '[]', info = '[]', hint = '[]'}},
				'encoding',
				'filetype',
			},
			lualine_y = {'progress'},
			lualine_z = {'location'}
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {'filename'},
			lualine_x = {'location'},
			lualine_y = {},
			lualine_z = {}
		},
		tabline = {},
		extensions = {'fugitive'}
	}

EOF

" Fix used language servers
let g:python3_host_prog = '/opt/homebrew/bin/python3'
let g:ruby_host_prog = '/Users/lpaehler/.rubies/ruby-3.1.2/bin/gem'
let g:perl_host_prog = '/usr/bin/perl'

