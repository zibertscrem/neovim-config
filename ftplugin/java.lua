local jdtls = require("jdtls")
local jdtls_dap = require("jdtls.dap")
local jdtls_setup = require("jdtls.setup")

local mason_path = require("mason-core.path")
local bundles = {}
vim.list_extend(
    bundles,
    vim.split(vim.fn.glob(mason_path.package_prefix("java-test") .. "/extension/server/*.jar", true), "\n")
)
vim.list_extend(
    bundles,
    vim.split(
        vim.fn.glob(
            mason_path.package_prefix("java-debug-adapter") .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
            true
        ),
        "\n"
    )
)
local config = {
    cmd = { mason_path.bin_prefix("jdtls") },
    root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "pom.xml" }, { upward = true })[1]),
    on_attach = function(_, bufnr)
        jdtls.setup_dap({ hotcodereplace = "auto" })
        jdtls_dap.setup_dap_main_class_configs()
        jdtls_setup.add_commands()
    end,
    init_options = {
        bundles = bundles,
    },
}
jdtls.start_or_attach(config)
