-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ "folke/lazy.nvim", opt = {}, lazy = true },

		{
			"tpope/vim-fugitive",
			keys = {
				{ "<leader>c", 'y<Esc>:GBrowse <C-R>"<CR>', "open link", mode = { "x" } },
				{ "<leader>s", 'y<Esc>:GBrowse https://www.google.com/search?q=<C-R>"<CR>', mode = { "x" } },
			},
			cmd = { "G", "Git", "Gbrowse" },
		},
		{ "tpope/vim-rhubarb", lazy = true },

		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {},
			keys = {
				{ "<leader>e", ":FzfLua files<CR>", "search files" },
				{ "<leader>b", ":FzfLua buffers<CR>", "search buffers" },
				{ "<leader>z", ":FzfLua spell_suggest<CR>", "search spell suggestions" },
				{ "<leader>g", ":FzfLua live_grep<CR>", "search grep" },
				{ "<leader>h", ":FzfLua help_tags<CR>", "search help tags" },
				{ "<leader>q", ":FzfLua quickfix<CR>", "search quickfix" },
				{ "<leader>/", ":FzfLua search_history<CR>", "search search history" },
				{ "<leader>.", ":FzfLua marks<CR>", "search marks" },
				{ "<leader>:", ":FzfLua command_history<CR>", "search command history" },
			},
			cmd = { "FzfLua" },
		},

		-- copilot
		{
			"zbirenbaum/copilot.lua",
			config = function()
				require("copilot").setup({
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
						yaml = true,
					},
				})
			end,
		},
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			dependencies = {
				{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
				{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
			},
			build = "make tiktoken",
			opts = {},
			keys = {
				{ "<leader>cc", ":CopilotChatToggle<CR>", "open chat" },
				{ "<leader>ccd", ":CopilotChatDocs<CR>", "open docs" },
				{ "<leader>cct", ":CopilotChatTests<CR>", "open tests" },
				{ "<leader>ccr", ":CopilotChatReview<CR>", "open review" },
			},
		},

		-- UI/appearance
		{
			"nvim-tree/nvim-web-devicons",
			opts = {
				update_focused_file = {
					enable = true,
					update_root = {
						enable = true,
					},
				},
			},
			keys = {
				{ "<leader>f", ":NvimTreeFindFileToggle!<CR>", "toggle tree" },
			},
			config = function()
				vim.api.nvim_create_autocmd("VimEnter", {
					desc = "Open NvimTree",
					pattern = "*",
					callback = function()
						if not vim.v.std_in then
							if vim.fn.argc() == 0 and vim.filetype ~= "man" then
								vim.cmd("NvimTreeOpen")
							elseif vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv()[1]) ~= 0 then
								vim.cmd("execute 'NvimTreeOpen' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0]")
							end
						end
					end,
				})
			end,
		},
		{
			"akinsho/bufferline.nvim",
			dependencies = "nvim-tree/nvim-web-devicons",
			opts = {
				options = {
					numbers = "buffer_id",
				},
			},
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			opts = {},
		},
		{ "AndreM222/copilot-lualine" },
		{
			"nvim-lualine/lualine.nvim",
			dependencies = "nvim-tree/nvim-web-devicons",
			opts = {
				sections = {
					lualine_x = { "copilot", "encoding", "fileformat", "filetype" },
				},
			},
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
			opts = {
				highlight = { enable = true },
				indent = { enable = true },
				ensure_installed = {},
			},
		},
		{
			"Mofiqul/vscode.nvim",
			lazy = false,
			config = function()
				vim.cmd([[colorscheme vscode]])
			end,
		},
		{ "kshenoy/vim-signature" },
		{ "pedrohdz/vim-yaml-folds" },
		{ "arecarn/vim-clean-fold" },
		{ "nvim-tree/nvim-tree.lua", opts = {} },

		-- Keybindings
		{ "christoomey/vim-tmux-navigator" },
		{ "RyanMillerC/better-vim-tmux-resizer" },
		{ "vim-utils/vim-husk" },
		{ "tpope/vim-surround" },
		{ "tpope/vim-repeat" },
		{ "tpope/vim-abolish" },

		-- Autocompletion
		{ "zbirenbaum/copilot-cmp" },
		{ "hrsh7th/cmp-nvim-lsp-signature-help" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-buffer" },
		{ "onsails/lspkind.nvim", opts = {} },
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			config = function()
				local cmp = require("cmp")
				local lspkind = require("lspkind")

				-- local cmp_kinds = {
				--   Text = "  ",
				--   Method = "  ",
				--   Function = "  ",
				--   Constructor = "  ",
				--   Field = "  ",
				--   Variable = "  ",
				--   Class = "  ",
				--   Interface = "  ",
				--   Module = "  ",
				--   Property = "  ",
				--   Unit = "  ",
				--   Value = "  ",
				--   Enum = "  ",
				--   Keyword = "  ",
				--   Snippet = "  ",
				--   Color = "  ",
				--   File = "  ",
				--   Reference = "  ",
				--   Folder = "  ",
				--   EnumMember = "  ",
				--   Constant = "  ",
				--   Struct = "  ",
				--   Event = "  ",
				--   Operator = "  ",
				--   TypeParameter = "  ",
				--   Copilot = " ",
				-- }

				local has_words_before = function()
					unpack = unpack or table.unpack
					local line, col = unpack(vim.api.nvim_win_get_cursor(0))
					return col ~= 0
						and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
				end

				cmp.setup({
					sources = {
						{ name = "copilot" },
						{ name = "nvim_lsp" },
						{ name = "nvim_lsp_signature_help" },
						{ name = "buffer" },
						{ name = "path" },
					},
					mapping = cmp.mapping.preset.insert({
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif has_words_before() then
								cmp.complete()
							else
								fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
							end
						end, { "i", "s" }),

						["<S-Tab>"] = cmp.mapping(function()
							if cmp.visible() then
								cmp.select_prev_item()
							end
						end, { "i", "s" }),
						["<C-E>"] = cmp.mapping(function(fallback)
							fallback()
						end),
					}),
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
					formatting = {
						format = lspkind.cmp_format({
							mode = "symbol_text", -- show only symbol annotations
							maxwidth = {
								-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
								-- can also be a function to dynamically calculate max width such as
								-- menu = function() return math.floor(0.45 * vim.o.columns) end,
								menu = 50, -- leading text (labelDetails)
								abbr = 50, -- actual suggestion item
							},
							ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
							show_labelDetails = true, -- show labelDetails in menu. Disabled by default
						}),
					},

					-- formatting = {
					--   fields = { "kind", "abbr" },
					--   format = function(_, vim_item)
					--     vim_item.kind = cmp_kinds[vim_item.kind] or ""
					--     return vim_item
					--   end,
					-- },
				})
			end,
		},

		-- LSP
		{ "williamboman/mason.nvim", opts = {} },
		{ "williamboman/mason-lspconfig.nvim" },
		{
			"neovim/nvim-lspconfig",
			cmd = { "LspInfo", "LspInstall", "LspStart" },
			event = { "BufReadPre", "BufNewFile" },
			dependencies = {
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "williamboman/mason.nvim" },
				{ "williamboman/mason-lspconfig.nvim" },
			},
			init = function()
				-- Reserve a space in the gutter
				-- This will avoid an annoying layout shift in the screen
				vim.opt.signcolumn = "yes"
			end,
			config = function()
				local lsp_defaults = require("lspconfig").util.default_config

				-- Add cmp_nvim_lsp capabilities settings to lspconfig
				-- This should be executed before you configure any language server
				lsp_defaults.capabilities = vim.tbl_deep_extend(
					"force",
					lsp_defaults.capabilities,
					require("cmp_nvim_lsp").default_capabilities()
				)

				-- LspAttach is where you enable features that only work
				-- if there is a language server active in the file
				vim.api.nvim_create_autocmd("LspAttach", {
					desc = "LSP actions",
					callback = function(event)
						local opts = { buffer = event.buf }

						vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
						vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
						vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
						vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
						vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
						vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
						vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
						vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
						vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
						vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
					end,
				})

				require("mason-lspconfig").setup({
					ensure_installed = {},
					handlers = {
						-- this first function is the "default handler"
						-- it applies to every language server without a "custom handler"
						function(server_name)
							if server_name == "lua_ls" then
								return require("lspconfig")[server_name].setup({
									settings = {
										Lua = {
											diagnostics = {
												globals = { "vim" },
											},
										},
									},
								})
							else
								require("lspconfig")[server_name].setup({})
							end
						end,
					},
				})
			end,
		},

		-- auto-format
		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					-- Customize or remove this keymap to your liking
					"<leader>f",
					function()
						require("conform").format({ async = true })
					end,
					mode = "",
					desc = "Format buffer",
				},
			},
			-- This will provide type hinting with LuaLS
			opts = {
				-- Define your formatters
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt", "goimports" },
					python = { "isort", "black" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
				},
				-- Set default options
				default_format_opts = {
					lsp_format = "fallback",
				},
				-- Set up format-on-save
				format_on_save = { timeout_ms = 500 },
				-- Customize formatters
				formatters = {
					shfmt = {
						prepend_args = { "-i", "2" },
					},
				},
			},
			init = function()
				-- If you want the formatexpr, here is the place to set it
				vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			end,
		},
		{
			"hedyhli/outline.nvim",
			lazy = true,
			cmd = { "Outline", "OutlineOpen" },
			keys = { -- Example mapping to toggle outline
				{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
			},
			opts = {
				-- Your setup opts here
			},
		},
	},
})

-- Filetype settings
vim.cmd("syntax on")
vim.cmd("filetype on")
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")

-- General settings
vim.opt.compatible = false
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = false
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.visualbell = true
vim.opt.encoding = "UTF-8"
vim.opt.path:append("**")
vim.opt.hidden = true
vim.opt.splitright = true
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.wildmenu = true
vim.opt.omnifunc = "syntaxcomplete#Complete"
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.undofile = true
vim.opt.undodir = "$HOME/.vim/undo//"
vim.opt.backupdir = { "$HOME/.vim/swap//", ".", "/tmp" }
vim.opt.directory = { "$HOME/.vim/swap//", ".", "/tmp" }
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.virtualedit = "block"
vim.opt.mouse = "a"
vim.opt.scrolloff = 5
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }
vim.opt.laststatus = 2

-- Key mappings
vim.api.nvim_set_keymap("i", "jk", "<esc>", { noremap = true })
vim.api.nvim_set_keymap("c", "bb", "b#", { noremap = true })

-- Highlighting
vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#808080" })

-- Source local configuration
vim.cmd([[source ~/.vimrc.local]])
