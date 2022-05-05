local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then return end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
  local default_opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities
  }

  local server_opts = {
    ["jsonls"] = function(opts)
      local jsonls_opts = require("user.lsp.settings.jsonls")
      return vim.tbl_deep_extend("force", opts, jsonls_opts)
    end,
    ["sumneko_lua"] = function(opts)
      local sumneko_opts = require("user.lsp.settings.sumneko_lua")
      return require("lua-dev").setup({
        lspconfig = vim.tbl_deep_extend("force", opts, sumneko_opts)
      })
    end
  }

  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(server_opts[server.name] and
    server_opts[server.name](default_opts) or default_opts)
end)
