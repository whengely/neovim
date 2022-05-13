local _M = {}

_M.createBranch = function()
	local prompt = "Enter Branch Name: "
	vim.ui.input({ prompt = prompt }, function(input)
		if input ~= nil then
			vim.cmd("!git ticket " .. input)
		end
	end)
end

_M.set_terminal_keymaps = function()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

_M.powerline = {
	circle = {
		left = "",
		right = "",
	},
	arrow = {
		left = "",
		right = "",
	},
	triangle = {
		left = "",
		right = "",
	},
	none = {
		left = "",
		right = "",
	},
}

_M.signs = { Error = "", Warn = "", Hint = "", Info = "" }
_M.setSpacesSize = function(filetypes)
	for filetype, size in pairs(filetypes) do
		vim.api.nvim_create_autocmd("FileType", {
			pattern = filetype,
			callback = function()
				vim.opt.shiftwidth = size
				vim.opt.tabstop = size
			end,
		})
	end
end

_M.buf_command = function(bufnr, name, fn, opts)
	vim.api.nvim_buf_create_user_command(bufnr, name, fn, opts or {})
end

_M.table = {
	some = function(tbl, cb)
		for k, v in pairs(tbl) do
			if cb(k, v) then
				return true
			end
		end
		return false
	end,
}

return _M
