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
        "debugpy",
        "delve",
    },
})
