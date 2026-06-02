lua << EOF
require("codecompanion").setup({
    adapters = {
        http = {
            ollama = function()
                return require("codecompanion.adapters").extend("ollama", {
                    env = {
                        url = os.getenv("OLLAMA_HOST") or "http://127.0.0.1:11434",
                    },
                    schema = {
                        model = {
                            default = "minimax-m3:cloud",
                        },
                    },
                })
            end,
            ["llama.cpp"] = function()
                return require("codecompanion.adapters").extend("openai_compatible", {
                    env = {
                        url = "http://127.0.0.1:8080",
                        api_key = "TERM",
                        chat_url = "/v1/chat/completions",
                    },
                    schema = {
                        model = {
                            default = "minimax-m3:cloud",
                        },
                    },
                })
            end,
        },
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
        inline = {
            adapter = "ollama",
        },
    },
})
EOF
