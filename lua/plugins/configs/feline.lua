local colors = require("theme").colors
local List = require("plenary.collections.py_list")

local vi_mode_colors = {
    NORMAL = colors.green,
    INSERT = colors.blue,
    VISUAL = colors.magenta,
    OP = colors.green,
    BLOCK = colors.blue,
    REPLACE = colors.red,
    ["V-REPLACE"] = colors.red,
    ENTER = colors.cyan,
    MORE = colors.cyan,
    SELECT = colors.orange,
    COMMAND = colors.magenta,
    SHELL = colors.green,
    TERM = colors.blue,
    NONE = colors.yellow
}

local function file_osinfo()
    local os = vim.bo.fileformat:upper()
    local icon
    if os == "UNIX" then
        icon = " "
    elseif os == "MAC" then
        icon = " "
    else
        icon = " "
    end
    return icon .. os
end

local lsp_get_diag = function(severity)
    local diagnostics = List(vim.diagnostic.get(0, {severity = severity}))
    local count = diagnostics:__len()
    return (count > 0) and " " .. count .. " " or ""
end

local vi_mode_utils = require("feline.providers.vi_mode")
local lsp = require("feline.providers.lsp")

local properties = {
    force_inactive = {
        filetypes = {
            "NvimTree", "dbui", "packer", "startify", "fugitive",
            "fugitiveblame"
        },
        buftypes = {"terminal"},
        bufnames = {}
    }
}
local comps = {
    vi_mode = {
        left = {
            provider = function()
                return "  " .. vi_mode_utils.get_vim_mode()
            end,
            hl = function()
                local val = {
                    name = vi_mode_utils.get_mode_highlight_name(),
                    fg = vi_mode_utils.get_mode_color()
                    -- fg = colors.bg
                }
                return val
            end,
            right_sep = " "
        },
        right = {
            -- provider = '▊',
            provider = "",
            hl = function()
                local val = {
                    name = vi_mode_utils.get_mode_highlight_name(),
                    fg = vi_mode_utils.get_mode_color()
                }
                return val
            end,
            left_sep = " ",
            right_sep = " "
        }
    },
    file = {
        info = {
            provider = {
                name = "file_info",
                opts = {
                    type = "relative-short",
                    file_readonly_icon = "  ",
                    -- file_readonly_icon = '  ',
                    -- file_readonly_icon = '  ',
                    -- file_readonly_icon = '  ',
                    -- file_modified_icon = '',
                    file_modified_icon = ""
                    -- file_modified_icon = 'ﱐ',
                    -- file_modified_icon = '',
                    -- file_modified_icon = '',
                    -- file_modified_icon = '',
                }
            },
            hl = {fg = colors.blue, style = "bold"}
        },
        encoding = {
            provider = "file_encoding",
            left_sep = " ",
            hl = {fg = colors.violet, style = "bold"}
        },
        type = {provider = "file_type"},
        os = {
            provider = file_osinfo,
            left_sep = " ",
            hl = {fg = colors.violet, style = "bold"}
        },
        position = {
            provider = "position",
            left_sep = " ",
            hl = {
                fg = colors.cyan
                -- style = 'bold'
            }
        }
    },
    left_end = {
        provider = function() return "" end,
        hl = {fg = colors.bg, bg = colors.blue}
    },
    line_percentage = {
        provider = "line_percentage",
        left_sep = " ",
        hl = {style = "bold"}
    },
    scroll_bar = {
        provider = "scroll_bar",
        left_sep = " ",
        hl = {fg = colors.blue, style = "bold"}
    },
    diagnos = {
        err = {
            -- provider = 'diagnostic_errors',
            provider = function()
                return "" .. lsp_get_diag(vim.diagnostic.severity.ERROR)
            end,
            -- left_sep = ' ',
            enabled = function()
                return lsp.diagnostics_exist("Error")
            end,
            hl = {fg = colors.red}
        },
        warn = {
            -- provider = 'diagnostic_warnings',
            provider = function()
                return "" .. lsp_get_diag(vim.diagnostic.severity.WARN)
            end,
            -- left_sep = ' ',
            enabled = function() return lsp.diagnostics_exist("Warn") end,
            hl = {fg = colors.yellow}
        },
        info = {
            -- provider = 'diagnostic_info',
            provider = function()
                return "" .. lsp_get_diag(vim.diagnostic.severity.INFO)
            end,
            -- left_sep = ' ',
            enabled = function() return lsp.diagnostics_exist("Info") end,
            hl = {fg = colors.blue}
        },
        hint = {
            -- provider = 'diagnostic_hints',
            provider = function()
                return "" .. lsp_get_diag(vim.diagnostic.severity.HINT)
            end,
            -- left_sep = ' ',
            enabled = function() return lsp.diagnostics_exist("Hint") end,
            hl = {fg = colors.cyan}
        }
    },
    lsp = {
        name = {
            provider = "lsp_client_names",
            -- left_sep = ' ',
            right_sep = " ",
            -- icon = '  ',
            icon = "慎",
            hl = {fg = colors.yellow}
        }
    },
    git = {
        branch = {
            provider = "git_branch",
            icon = " ",
            -- icon = ' ',
            left_sep = " ",
            hl = {fg = colors.violet, style = "bold"}
        },
        add = {provider = "git_diff_added", hl = {fg = colors.green}},
        change = {provider = "git_diff_changed", hl = {fg = colors.orange}},
        remove = {provider = "git_diff_removed", hl = {fg = colors.red}}
    }
}

local components = {active = {}, inactive = {}}

table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.inactive, {})
table.insert(components.inactive, {})
table.insert(components.inactive, {})

table.insert(components.active[1], comps.vi_mode.left)
table.insert(components.active[1], comps.file.info)
table.insert(components.active[1], comps.git.branch)
table.insert(components.active[1], comps.git.add)
table.insert(components.active[1], comps.git.change)
table.insert(components.active[1], comps.git.remove)
table.insert(components.inactive[1], comps.vi_mode.left)
table.insert(components.inactive[1], comps.file.info)
table.insert(components.active[3], comps.diagnos.err)
table.insert(components.active[3], comps.diagnos.warn)
table.insert(components.active[3], comps.diagnos.hint)
table.insert(components.active[3], comps.diagnos.info)
table.insert(components.active[3], comps.lsp.name)
table.insert(components.active[3], comps.file.os)
table.insert(components.active[3], comps.file.position)
table.insert(components.active[3], comps.line_percentage)
table.insert(components.active[3], comps.scroll_bar)
table.insert(components.active[3], comps.vi_mode.right)

-- TreeSitter
-- local ts_utils = require("nvim-treesitter.ts_utils")
-- local ts_parsers = require("nvim-treesitter.parsers")
-- local ts_queries = require("nvim-treesitter.query")
--[[ table.insert(components.active[2], {
  provider = function()
    local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
    return ("%d:%s [%d, %d] - [%d, %d]")
      :format(node:symbol(), node:type(), node:range())
  end,
  enabled = function()
    local ok, ts_parsers = pcall(require, "nvim-treesitter.parsers")
    return ok and ts_parsers.has_parser()
  end
}) ]]

require("feline").setup({
    default_bg = colors.bg,
    default_fg = colors.fg,
    components = components,
    properties = properties,
    vi_mode_colors = vi_mode_colors
})
