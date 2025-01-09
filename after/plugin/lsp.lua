local lsp_zero = require("lsp-zero")
local cmp = require("cmp")
local telescope_builtin = require("telescope.builtin")

local function on_attach(_, bufnr)
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

    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
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
    vim.keymap.set({ "n", "v" }, "<leader>ca", function()
        vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "<leader>vr", function()
        vim.lsp.buf.references({ includeDeclaration = false }, {
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
    vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
    vim.keymap.set("n", "<leader>fs", "<cmd>LspStart<CR>", opts)
    vim.keymap.set("n", "<leader>hrs", function()
        local detach_clients = {}
        local clients = require("lspconfig.util").get_lsp_clients({ bufnr = bufnr })
        for _, client in ipairs(clients) do
            if client.attached_buffers[bufnr] then
                detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
                client.stop(true)
                local timer = vim.loop.new_timer()
                timer:start(
                    500,
                    100,
                    vim.schedule_wrap(function()
                        for client_name, tuple in pairs(detach_clients) do
                            if require("lspconfig.configs")[client_name] then
                                local client, attached_buffers = unpack(tuple)
                                if client.is_stopped() then
                                    for _, buf in pairs(attached_buffers) do
                                        require("lspconfig.configs")[client_name].launch(buf)
                                    end
                                    detach_clients[client_name] = nil
                                end
                            end
                        end

                        if next(detach_clients) == nil and not timer:is_closing() then
                            timer:close()
                        end
                    end)
                )
            end
        end
        -- lsputil.get_lsp_clients({ }
    end, opts)
    local goimpl = require("goimpl")
    if goimpl.is_go() then
        vim.keymap.set("n", "<leader>im", function()
            require("goimpl").impl()
        end, opts)
    end
end

lsp_zero.on_attach(on_attach)
require("lspconfig").mojo.setup({
    on_attach = on_attach,
})

if os.getenv("WSL_DISTRO_NAME") ~= nil then
    require("lspconfig").gdscript.setup({
        filetypes = { "gd", "gdscript" },
        on_attach = on_attach,
        cmd = { "godot-wsl-lsp", "--useMirroredNetworking" },
    })
else
    require("lspconfig").gdscript.setup({
        filetypes = { "gd", "gdscript" },
        on_attach = on_attach,
    })
end

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        -- LSPs
        "rust_analyzer",
        "pylsp",
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
        jdtls = function() end,
        rust_analyzer = function() end,
        pylsp = function()
            require("lspconfig").pylsp.setup({
                settings = {
                    pylsp = {
                        plugins = {
                            rope_autoimport = {
                                enabled = true,
                                memory = true,
                            },
                            rope_completion = {
                                enabled = true,
                            },
                            ruff = {
                                enabled = true,
                                formatEnabled = true,
                                format = { "I" },
                                extendSelect = { "ALL" },
                                extendIgnore = { "CPY", "ANN", "D", "PL", "FA" },
                                extendFixable = { "ALL" },
                                extendSafeFixes = { "ALL" },
                                unsafeFixes = true,
                                lineLength = 120,
                                preview = true,
                            },
                            pylsp_mypy = {
                                enabled = true,
                                live_mode = true,
                                strict = true,
                            },
                        },
                    },
                },
            })
        end,
    },
})

local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = "luasnip", keyword_length = 2 },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "nvim_lua" },
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
