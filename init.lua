-- ============================================================================
-- LEADER
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- OPTIONS
-- ============================================================================
vim.opt.number = true -- line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true -- highlight current line
vim.opt.wrap = false -- do not wrap lines by default
vim.opt.scrolloff = 10 -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10 -- keep 10 lines to left/right of cursor

vim.opt.tabstop = 4 -- tabwidth
vim.opt.shiftwidth = 4 -- indent width
vim.opt.softtabstop = 4 -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = false -- use spaces instead of tabs
vim.opt.smartindent = true -- smart auto-indent
vim.opt.autoindent = true -- copy indent from current line

vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- case sensitive if uppercase in string
vim.opt.hlsearch = true -- highlight search matches
vim.opt.incsearch = true -- show matches as you type

-- ============================================================================
-- PLUGINS
-- ============================================================================
vim.pack.add {
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim", name = "gruvbox" },

	-- LSP configurations
    { src = "https://github.com/neovim/nvim-lspconfig" },

	-- FZF
	{ src = "https://github.com/ibhagwan/fzf-lua" },

	-- Oil
	{ src = "https://github.com/stevearc/oil.nvim" },
}

-- ============================================================================
-- COLORSCHEME
-- ============================================================================
vim.opt.termguicolors = true
vim.opt.background = "dark"

require("gruvbox").setup({
    contrast = "hard",
})
vim.cmd.colorscheme("gruvbox")
--vim.cmd.colorscheme('catppuccin')

-- ============================================================================
-- LSP
-- ============================================================================
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.pumheight = 10 -- maximum completion menu height

-- Completion keymaps
vim.keymap.set("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-n>"
	end
	return "<Tab>"
end, { expr = true })

vim.keymap.set("i", "<S-Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-p>"
	end
	return "<S-Tab>"
end, { expr = true })

vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-y>"
	end
	return "<CR>"
end, { expr = true })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local opts = { buffer = args.buf }

		-- Go to definition
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        -- Show references
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

		-- Hover documentation
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

		-- Rename symbol
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		-- Code action
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

		-- LSP completion
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, args.buf, {
				autotrigger = true,
			})
		end
	end,
})

vim.lsp.enable("clangd")

-- ============================================================================
-- FZF
-- ============================================================================
require("fzf-lua").setup({
	keymap = {
		fzf = {
			["Ctrl-n"] = "down",
			["Ctrl-p"] = "up",
		},
	},
})

vim.keymap.set("n", "<leader>ff", function()
    require("fzf-lua").files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
    require("fzf-lua").live_grep()
end, { desc = "Live grep" })

vim.keymap.set("n", "<leader>fb", function()
    require("fzf-lua").buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<leader>fh", function()
    require("fzf-lua").helptags()
end, { desc = "Help tags" })

-- ============================================================================
-- Oil
-- ============================================================================
require("oil").setup({
	default_file_explorer = true,

	view_options = {
		show_hidden = true,
	},
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", {
	desc = "Open parent directory",
})

