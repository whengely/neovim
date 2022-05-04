local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.lsp.lsp-installer"
require("user.lsp.handlers").setup()
require "user.lsp.null-ls"
require "user.lsp.lightbulb"


-- code action menu
vim.g.code_action_menu_show_details = true
vim.g.code_action_menu_show_diff = true
