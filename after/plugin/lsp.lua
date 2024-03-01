local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set("n", "gD", function()
        vim.lsp.buf.declaration()
    end, opts)
    vim.keymap.set("n", "gi", function()
        vim.lsp.buf.implementation()
    end, opts)
    vim.keymap.set("n", "go", function()
        vim.lsp.buf.type_definition()
    end, opts)
    vim.keymap.set("n", "<leader>ws", function()
        vim.lsp.buf.workspace_symbol()
    end, opts)
    vim.keymap.set("n", "<leader>vd", function()
        vim.diagnostic.open_float()
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
        vim.lsp.buf.references()
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
        "docker_compose_language_service",
        "dockerls",
        "marksman",
        "sqlls",
        "html-lsp",
        "htmx-lsp",
    },
    automatic_installation = true,
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
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

local cmp = require("cmp")
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
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
})
