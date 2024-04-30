local status, jdtls = pcall(require, "jdtls")
if not status then
    vim.notify("jdtls not found")
    return
end

local java_test_jar = vim.fn.glob "$MASON/share/java-test/com.microsoft.java.test.plugin-*.jar"
local java_debug_adapter = vim.fn.glob "$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar"
local jdtls_path = require('mason-registry').get_package('jdtls'):get_install_path()

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.env.HOME .. '/jdtls-workspace/' .. project_name

local bundles = {
    java_debug_adapter,
    java_test_jar,
}

local os = 'linux'

local this_os = vim.loop.os_uname().sysname

if this_os:find "Windows" then
    os = 'win'
end


-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-javaagent:' .. jdtls_path .. '/lombok.jar',
        '-Xmx4g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        -- Eclipse jdtls location
        '-jar', vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
        -- TODO Update this to point to the correct jdtls subdirectory for your OS (config_linux, config_mac, config_win, etc)
        '-configuration', jdtls_path .. '/config_' .. os,
        '-data', workspace_dir
    },

    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'pom.xml', 'build.gradle' }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    settings = {
        java = {
            home = vim.fn.glob '$JAVA_HOME',
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                -- TODO Update this by adding any runtimes that you need to support your Java projects and removing any that you don't have installed
                -- The runtime name parameters need to match specific Java execution environments.  See https://github.com/tamago324/nlsp-settings.nvim/blob/2a52e793d4f293c0e1d61ee5794e3ff62bfbbb5d/schemas/_generated/jdtls.json#L317-L334
                runtimes = {
                    -- {
                    --   name = "JavaSE-11",
                    --   path = "/usr/lib/jvm/java-11-openjdk-amd64",
                    -- },
                    -- {
                    --   name = "JavaSE-17",
                    --   path = "/usr/lib/jvm/java-17-openjdk-amd64",
                    -- },
                    -- {
                    --   name = "JavaSE-19",
                    --   path = "/usr/lib/jvm/java-19-openjdk-amd64",
                    -- }
                }
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            signatureHelp = { enabled = true },
            format = {
                enabled = true,
                -- Formatting works by default, but you can refer to a specific file/URL if you choose
                -- settings = {
                --   url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
                --   profile = "GoogleStyle",
                -- },
            },
        },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
            importOrder = {
                "java",
                "javax",
                "com",
                "org"
            },
        },
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    },
    -- Needed for auto-completion with method signatures and placeholders
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    flags = {
        allow_incremental_sync = true,
    },
    init_options = {
        -- References the bundles defined above to support Debugging and Unit Testing
        bundles = bundles
    },
}

-- Needed for debugging
config['on_attach'] = function(client, bufnr)
    vim.notify("on attach java")
    jdtls.setup_dap({ hotcodereplace = 'auto' })
    require('jdtls.dap').setup_dap_main_class_configs()
end

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
jdtls.start_or_attach(config)













local lsp = require("flye.lsp-common")

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
-- local config = {
--     -- The command that starts the language server
--     -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
--     cmd = {
--
--         -- 💀
--         'java', -- or '/path/to/java17_or_newer/bin/java'
--         -- depends on if `java` is in your $PATH env variable and if it points to the right version.
--
--         '-Declipse.application=org.eclipse.jdt.ls.core.id1',
--         '-Dosgi.bundles.defaultStartLevel=4',
--         '-Declipse.product=org.eclipse.jdt.ls.core.product',
--         '-Dlog.protocol=true',
--         '-Dlog.level=ALL',
--         '-Xmx1g',
--         '--add-modules=ALL-SYSTEM',
--         '--add-opens', 'java.base/java.util=ALL-UNNAMED',
--         '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
--
--         -- 💀
--         -
--         '-jar', '' .. lsp.get_eclipse_launcher(),
--         -- '-jar', '/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
--         -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
--         -- Must point to the                                                     Change this to
--         -- eclipse.jdt.ls installation                                           the actual version
--
--
--         -- 💀
--         '-configuration', '' .. lsp.get_jdtls_config_dir(),
--         -- '-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
--         -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
--         -- Must point to the                      Change to one of `linux`, `win` or `mac`
--         -- eclipse.jdt.ls installation            Depending on your system.
--
--
--         -- 💀
--         -- See `data directory configuration` section in the README
--         -- '-data', '/path/to/unique/per/project/workspace/folder'
--     },
--
--     -- 💀
--     -- This is the default if not provided, you can remove it. Or adjust as needed.
--     -- One dedicated LSP server & client will be started per unique root_dir
--     root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),
--
--     -- Here you can configure eclipse.jdt.ls specific settings
--     -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
--     -- for a list of options
--     settings = {
--         java = {
--         }
--     },
--
--     -- Language server `initializationOptions`
--     -- You need to extend the `bundles` with paths to jar files
--     -- if you want to use additional eclipse.jdt.ls plugins.
--     --
--     -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
--     --
--     -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
--     init_options = {
--         bundles = {}
--     },
-- }
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.


vim.notify("after creating config")
-- jdtls.start_or_attach(config)
vim.notify("after start")
