local mason_installer = require("mason-tool-installer")

mason_installer.setup({
    ensure_installed = {
        -- Formatters
        "isort",
        "black",
        "stylua",
        "prettier",
        "sql-formatter",
        -- Tools
        "impl",
        -- DAPs
        "debugpy",      -- Python
        "delve",        -- Go
        "codelldb",     -- C/C++/Rust
        "java-debug-adapter", -- Java
    },
})
