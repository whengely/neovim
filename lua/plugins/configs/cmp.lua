local ok, cmp = pcall(require, "cmp")

if not ok then
	return
end

local compare = cmp.config.compare

--   פּ ﯟ   some other good icons
local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup({
	experimental = {
		native_menu = false,
		ghost_text = false,
	},
	confirmation = {
		get_commit_characters = function()
			return {}
		end,
	},
	completion = {
		completeopt = "menu,menuone,noinsert",
		keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
		keyword_length = 1,
	},
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-q>"] = cmp.mapping.close(),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes("<Plug>(vsnip-expand-or-jump)", true, true, true),
					"",
					true
				)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true),
					"",
					true
				)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			vim_item.menu = ({
				npm = "[npm]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				vsnip = "[VSnippet]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
				nvim_lsp_signature_help = "[LSP Sig]",
			})[entry.source.name]
			return vim_item
		end,
	},
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	sources = {
		{ name = "npm" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "vsnip" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "nvim_lsp_signature_help" },
	},
	sorting = {
		priority_weight = 1.0,
		comparators = {
			-- compare.score_offset, --not good at all
			compare.locality,
			compare.recently_used,
			compare.score,
			-- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
			compare.offset,
			compare.order,
			-- compare.scopes, -- what?
			-- compare.sort_text,
			-- compare.exact,
			-- compare.kind,
			-- compare.length, -- useless
		},
	},
	preselect = cmp.PreselectMode.None,
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
