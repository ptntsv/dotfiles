vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.mouse = "a"
vim.opt.pumheight = 15
vim.splitbelow = true
vim.splitright = false
vim.opt.termguicolors = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.guicursor = ""

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

--
-- PLUGINS
--
local plugins = {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    { "miikanissi/modus-themes.nvim", priority = 1000 },
    {
        'jose-elias-alvarez/null-ls.nvim'
    },
    {
        'karoliskoncevicius/distilled-vim',
        'zekzekus/menguless',
        'catppuccin/nvim',
        'Mofiqul/dracula.nvim'

    },
    {
        "kyazdani42/blue-moon"
    },
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "L3MON4D3/LuaSnip",
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets'
    },
    {
        'numToStr/Comment.nvim',
        'windwp/nvim-autopairs',
    },
}
local opts = {}

vim.opt.rtp:prepend(lazypath)

require("lazy").setup(plugins, opts)
require('telescope').setup {
    defaults = {
    },
    pickers = {
        find_files = {
            layout_strategy = 'bottom_pane',
            theme = 'ivy',
            previewer = true,
            layout_config = {
                height = 0.4,
            }
        },
        live_grep = {
            layout_strategy = 'bottom_pane',
            theme = 'ivy',
            previewer = true,
            layout_config = {
                height = 0.4,
            }
        },
        buffers = {
            layout_strategy = 'bottom_pane',
            theme = 'ivy',
            previewer = true,
            layout_config = {
                height = 0.4,
            }
        }
    },
    extensions = {
        -- ...
    }
}

require("mason").setup()
require("mason-lspconfig").setup()
require("lspconfig").pyright.setup {}
-- require("lspconfig").lua_ls.setup {}
require("lspconfig").asm_lsp.setup {}
require("lspconfig").clangd.setup {}
require("luasnip.loaders.from_vscode").lazy_load()
require("nvim-autopairs").setup()
local cmp = require 'cmp'
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        -- { name = 'nvim_lsp' },
        -- { name = 'vsnip' }, -- For vsnip users.
        { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- An example for configuring `clangd` LSP to use nvim-cmp as a completion engine
require 'cmp'.setup {
    sources = {
        { name = 'nvim_lsp' }
    }
}
require('lspconfig').clangd.setup {
    capabilities = capabilities,
    ... -- other lspconfig configs
}
require('Comment').setup {
    padding = true,
    sticky = true,
    ignore = nil,
    toggler = {
        line = 'gcc',
        block = 'gbc',
    },
    opleader = {
        line = 'gc',
        block = 'gb',
    },
    extra = {
        above = 'gcO',
        below = 'gco',
        eol = 'gcA',
    },
    mappings = {
        basic = true,
        extra = true,
    },
    pre_hook = nil,
    post_hook = nil,
}
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")

require("null-ls").setup({
    -- you can reuse a shared lspconfig on_attach callback here
    sources = {
        null_ls.builtins.formatting.black,
    },
})
--
--
-- KEYMAPS
--
local keymap = vim.api.nvim_set_keymap
local remap_opts = { noremap = true, silent = true }
local builtin = require('telescope.builtin')

keymap('n', 'd[', ':lua vim.diagnostic.goto_next()<cr>', remap_opts)
keymap('n', 'd[', ':lua vim.diagnostic.goto_next()<cr>', remap_opts)
keymap('n', '[d', ':lua vim.diagnostic.goto_prev()<cr>', remap_opts)
keymap('n', 'gd', ':lua vim.lsp.buf.definition()<cr>', remap_opts)
keymap('n', 'K', ':lua vim.lsp.buf.hover()<cr>', remap_opts)
keymap('n', '<C-k>', ':lua vim.lsp.buf.signature_help()<cr>', remap_opts)
keymap('n', '<leader>rn', ':lua vim.lsp.buf.rename()<cr>', remap_opts)
keymap('n', '<C-M-L>', ':lua vim.lsp.buf.format({async=false})<cr>', remap_opts)

keymap('n', 'ge', '$', remap_opts)
keymap('n', 'gs', '^', remap_opts)

keymap('t', '<Esc>', '<C-\\><C-n>', remap_opts)
keymap('t', '<A-l>', '<C-\\><C-n><C-w>l', remap_opts)
keymap('t', '<A-h>', '<C-\\><C-n><C-w>h', remap_opts)
keymap('t', '<A-j>', '<C-\\><C-n><C-w>j', remap_opts)
keymap('t', '<A-k>', '<C-\\><C-n><C-w>k', remap_opts)

keymap('i', '<A-l>', '<C-\\><C-n><C-w>l', remap_opts)
keymap('i', '<A-h>', '<C-\\><C-n><C-w>h', remap_opts)
keymap('i', '<A-j>', '<C-\\><C-n><C-w>j', remap_opts)
keymap('i', '<A-k>', '<C-\\><C-n><C-w>k', remap_opts)

keymap('n', '<A-l>', '<C-w>l', remap_opts)
keymap('n', '<A-h>', '<C-w>h', remap_opts)
keymap('n', '<A-j>', '<C-w>j', remap_opts)
keymap('n', '<A-k>', '<C-w>k', remap_opts)

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
--
-- Default options
require("modus-themes").setup({
	-- Theme comes in two styles `modus_operandi` and `modus_vivendi`
	-- `auto` will automatically set style based on background set with vim.o.background
	style = "auto",
	variant = "tritanopia", -- Theme comes in four variants `default`, `tinted`, `deuteranopia`, and `tritanopia`
	transparent = false, -- Transparent background (as supported by the terminal)
	dim_inactive = false, -- "non-current" windows are dimmed
	styles = {
		-- Style to be applied to different syntax groups
		-- Value is any valid attr-list value for `:help nvim_set_hl`
		comments = { italic = false },
		keywords = { italic = false },
		functions = {},
		variables = {},
	},

	--- You can override specific color groups to use other groups or a hex color
	--- function will be called with a ColorScheme table
	---@param colors ColorScheme
	on_colors = function(colors) end,

	--- You can override specific highlights to use other groups or a hex color
	--- function will be called with a Highlights and ColorScheme table
	---@param highlights Highlights
	---@param colors ColorScheme
	on_highlights = function(highlights, colors) end,
})
-- vim.cmd.colorscheme("dracula")
