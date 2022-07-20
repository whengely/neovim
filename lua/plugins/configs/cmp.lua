local ok, cmp = pcall(require, "cmp")

if not ok then return end

local compare = cmp.config.compare

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true),
                          mode, true)
end

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
    TypeParameter = ""
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

local nextMapping = cmp.mapping(function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
    elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
    elseif has_words_before() then
        cmp.complete()
    else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
    end
end, {"i", "s"})

local previousMapping = cmp.mapping(function()
    if cmp.visible() then
        cmp.select_prev_item()
    elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
    end
end, {"i", "s"})

cmp.setup({
    experimental = {ghost_text = true},
    confirmation = {get_commit_characters = function() return {} end},
    completion = {
        completeopt = "menu,menuone,noinsert",
        keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
        keyword_length = 1
    },
    mapping = {
        ["<Esc>"] = cmp.mapping.abort(),
        ["<Tab>"] = nextMapping,
        ["<Down>"] = nextMapping,
        ["<S-Tab>"] = previousMapping,
        ["<Up>"] = previousMapping,
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
        })
    },
    formatting = {
        fields = {"kind", "abbr", "menu"},
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
                nvim_lsp_signature_help = "[LSP Sig]"
            })[entry.source.name]
            return vim_item
        end
    },
    snippet = {expand = function(args) vim.fn["vsnip#anonymous"](args.body) end},
    sources = {
        {name = "npm"}, {name = "nvim_lsp"}, {name = "nvim_lua"},
        {name = "vsnip"}, {name = "path"}, {name = "nvim_lsp_signature_help"}
    },
    sorting = {
        priority_weight = 1.0,
        comparators = {
            -- compare.score_offset, --not good at all
            compare.locality, compare.recently_used, compare.score,
            -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
            compare.offset, compare.order
            -- compare.scopes, -- what?
            -- compare.sort_text,
            -- compare.exact,
            -- compare.kind,
            -- compare.length, -- useless
        }
    },
    preselect = cmp.PreselectMode.None
})

cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{name = "buffer"}}
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{name = "path"}}, {{name = "cmdline"}})
})
