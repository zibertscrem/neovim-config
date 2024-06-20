local mason_installer = require("mason-tool-installer")

mason_installer.setup({
    ensure_installed = {
        -- Formatters
        "stylua",
        "prettier",
        "sql-formatter",
        "google-java-format",
        -- Tools
        "impl",
        -- DAPs
        "debugpy",      -- Python
        "delve",        -- Go
        "codelldb",     -- C/C++/Rust
        "java-debug-adapter", -- Java
        "java-test", -- Java
    },
})
