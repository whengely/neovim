local ok, wk = pcall(require, "which-key")

if not ok then return end

local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20 -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false,
            -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true -- bindings for prefixed with g
        }
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+" -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>" -- binding to scroll up inside the popup
    },
    window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
        padding = {2, 2, 2, 2}, -- extra window padding [top, right, bottom, left]
        winblend = 0
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left" -- align columns left, center or right
    },
    ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = {"j", "k"},
        v = {"j", "k"}
    }
}
local opts = {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true
}

local mappings = {
    ["a"] = {"<cmd>Alpha<cr>", "Alpha"},
    -- [[Illuminate]]
    ["<Tab>"] = {
        "<cmd>lua require'illuminate'.next_reference{wrap=true}<cr>",
        "[ILLUMINATE] Next reference"
    },
    ["<S-Tab>"] = {
        "<cmd>lua require'illuminate'.next_reference{reverse=true,wrap=true}<cr>",
        "[ILLUMINATE] Next reference"
    },
    e = {"<cmd>NvimTreeToggle<cr> <cmd>NvimTreeRefresh<cr>", "Nvim Tree Toggle"},
    R = {"<cmd>NvimTreeRefresh<cr>", "Nvim Tree Refresh"},
    ["]"] = {"<cmd>bprev<cr>", "Previous buffer"},
    ["["] = {"<cmd>bnext<cr>", "Next buffer"},
    c = {"<cmd>bd<cr>", "Close current buffer"},
    f = {
        "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", "Find File"
    },
    F = {"<cmd>Telescope live_grep<cr>", "Find File by grep"},

    b = {
        name = "Buffers",
        b = {
            "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
            "Buffers"
        },
        n = {"<cmd>bnext<cr>", "Next"},
        p = {"<cmd>bprev<cr>", "Previous"}
    },

    p = {
        name = "Packer",
        c = {"<cmd>PackerCompile<cr>", "Compile"},
        i = {"<cmd>PackerInstall<cr>", "Install"},
        s = {"<cmd>PackerSync<cr>", "Sync"},
        S = {"<cmd>PackerStatus<cr>", "Status"},
        u = {"<cmd>PackerUpdate<cr>", "Update"}
    },

    g = {
        name = "Git",
        g = {"<cmd>!git pull<CR>", "Pull"},
        l = {"<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame"},
        R = {"<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer"},
        o = {"<cmd>Telescope git_status<cr>", "Open changed file"},
        b = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
        c = {"<cmd>Telescope git_commits<cr>", "Checkout commit"},
        C = {"<cmd>!git close-branch<cr>", "Close branch"},
        d = {"<cmd>Gitsigns diffthis HEAD<cr>", "Diff"},
        t = {"<cmd>Neogit<cr>", "Commit"},
        p = {"<cmd>!git publish<cr>", "Publish"},
        P = {"<cmd>!git create-pull-request<cr>", "Pull Request"},
        u = {"<cmd>!git push<cr>", "Push"},
        B = {"<cmd>lua require('utils').createBranch()<cr>", "Branch"}
    },

    l = {
        name = "LSP",
        a = {"<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action"},
        d = {
            "<cmd>Telescope lsp_document_diagnostics<cr>",
            "Document Diagnostics"
        },
        w = {
            "<cmd>Telescope lsp_workspace_diagnostics<cr>",
            "Workspace Diagnostics"
        },
        f = {"<cmd>lua vim.lsp.buf.format()<cr>", "Format"},
        i = {"<cmd>LspInfo<cr>", "Info"},
        I = {"<cmd>LspInstallInfo<cr>", "Installer Info"},
        j = {"<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic"},
        k = {"<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic"},
        l = {"<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action"},
        q = {"<cmd>lua vim.diagnostic.set_loclist()<cr>", "Quickfix"},
        r = {"<cmd>lua vim.lsp.buf.rename()<cr>", "Rename"},
        s = {"<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"},
        S = {
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            "Workspace Symbols"
        }
    },
    s = {
        name = "Search",
        c = {"<cmd>Telescope colorscheme<cr>", "Colorscheme"},
        h = {"<cmd>Telescope help_tags<cr>", "Find Help"},
        M = {"<cmd>Telescope man_pages<cr>", "Man Pages"},
        r = {"<cmd>Telescope oldfiles<cr>", "Open Recent File"},
        R = {"<cmd>Telescope registers<cr>", "Registers"},
        m = {"<cmd>Telescope marks<cr>", "Marks"},
        k = {"<cmd>Telescope keymaps<cr>", "Keymaps"},
        C = {"<cmd>Telescope commands<cr>", "Commands"}
    },

    t = {
        name = "Terminal",
        f = {"<cmd>ToggleTerm direction=float<cr>", "Float"},
        h = {"<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal"},
        t = {"<cmd>ToggleTermToggleAll<cr>", "Toggle all"},
        v = {"<cmd>ToggleTerm size=60 direction=vertical<cr>", "Vertical"}
    }
}

wk.setup(setup)
wk.register(mappings, opts)
