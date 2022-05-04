local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then return end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local codeActions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion
local hover = null_ls.builtins.hover

null_ls.setup({
    debug = false,
    sources = {
      -- code actions
      codeActions.eslint_d,
      codeActions.gitrebase,
      codeActions.proselint,
      -- completion
      completion.luasnip,
      -- formatting
      formatting.prettierd,
      formatting.stylua,
      formatting.eslint_d,
      formatting.lua_format,
      formatting.markdownlint,
      -- diagnostics
      diagnostics.eslint_d,
      diagnostics.gitlint,
      diagnostics.jsonlint,
      diagnostics.luacheck,
      diagnostics.markdownlint,
      diagnostics.zsh,

      -- hover
        hover.dictionary
    }
})
