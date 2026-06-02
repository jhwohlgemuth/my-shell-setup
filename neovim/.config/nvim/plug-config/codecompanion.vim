lua << EOF
require("codecompanion").setup({
    adapters = {
        acp = {
            opencode = function()
                return require("codecompanion.adapters").extend("opencode", {
                    defaults = {
                        timeout = 20000,
                    },
                })
            end,
        },
    },
    interactions = {
        chat = {
            adapter = "opencode",
        },
    },
})
EOF
