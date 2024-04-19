local lsp_zero = require("lsp-zero")
local cmp = require("cmp")
local telescope_builtin = require("telescope.builtin")

lsp_zero.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set("n", "gd", function()
        telescope_builtin.lsp_definitions()
        -- vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set("n", "gD", function()
        vim.lsp.buf.declaration()
    end, opts)
    vim.keymap.set("n", "gi", function()
        telescope_builtin.lsp_implementations()
        -- vim.lsp.buf.implementation()
    end, opts)
    vim.keymap.set("n", "gI", function()
        telescope_builtin.lsp_incoming_calls()
        -- vim.lsp.buf.implementation()
    end, opts)
    vim.keymap.set("n", "go", function()
        telescope_builtin.lsp_type_definitions()
        -- vim.lsp.buf.type_definition()
    end, opts)
    vim.keymap.set("n", "gO", function()
        telescope_builtin.lsp_outgoing_calls()
        -- vim.lsp.buf.type_definition()
    end, opts)
    vim.keymap.set("n", "<leader>ws", function()
        telescope_builtin.lsp_workspace_symbols()
        -- vim.lsp.buf.workspace_symbol()
    end, opts)
    vim.keymap.set("n", "<leader>ds", function()
        telescope_builtin.lsp_document_symbols()
        -- vim.lsp.buf.workspace_symbol()
    end, opts)
    vim.keymap.set("n", "<leader>vd", function()
        -- Document diagnostics
        telescope_builtin.diagnostics({ bufnr = 0 })
        -- vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set("n", "<leader>wd", function()
        -- Workspace diagnostics
        telescope_builtin.diagnostics()
        -- vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.goto_next()
    end, opts)
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.goto_prev()
    end, opts)
    vim.keymap.set("n", "<leader>ca", function()
        vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "<leader>vr", function()
        vim.lsp.buf.references(nil, {
            on_list = function(options)
                vim.fn.setqflist({}, " ", options)
                telescope_builtin.quickfix()
            end,
        })
    end, opts)
    vim.keymap.set("n", "<leader>vn", function()
        vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
    end, opts)
    local goimpl = require("goimpl")
    if goimpl.is_go() then
        vim.keymap.set("n", "<leader>im", function()
            require("goimpl").impl()
        end, opts)
    end
end)

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        -- LSPs
        "rust_analyzer",
        "pyright",
        "lua_ls",
        "gopls",
        "zls",
        "docker_compose_language_service",
        "dockerls",
        "marksman",
        "sqlls",
        "html",
        "htmx",
        "jdtls",
    },
    automatic_installation = true,
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            require("neodev").setup({})
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
        end,
        gopls = function()
            local go_opts = {
                cmd = { "gopls", "-remote=auto" },
                -- attach to new filetypes too.
                filetypes = { "go", "gomod", "gowork", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
                settings = {
                    gopls = {
                        -- see ftdetect/go.lua.
                        ["build.templateExtensions"] = { "gohtml", "html", "gotmpl", "tmpl", "go.html", "go.tmpl" },
                    },
                },
                -- rest of your config.
            }
            require("lspconfig").gopls.setup(go_opts)
        end,
    },
})

local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip", keyword_length = 2 },
        { name = "buffer",  keyword_length = 3 },
    },
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-i>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-q>"] = cmp.mapping.close(),
    }),
})
