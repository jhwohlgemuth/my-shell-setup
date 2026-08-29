lua << EOF
local ok, snacks = pcall(require, "snacks")
if not ok then
    return
end

snacks.setup({
    animate = { enabled = true },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dashboard = {
        enabled = true,
        preset = {
            header = [[
    ███╗░░██╗███████╗░█████╗░██╗░░░██╗██╗███╗░░░███╗
    ████╗░██║██╔════╝██╔══██╗██║░░░██║██║████╗░████║
    ██╔██╗██║█████╗░░██║░░██║╚██╗░██╔╝██║██╔████╔██║
    ██║╚████║██╔══╝░░██║░░██║░╚████╔╝░██║██║╚██╔╝██║
    ██║░╚███║███████╗╚█████╔╝░░╚██╔╝░░██║██║░╚═╝░██║
    ╚═╝░░╚══╝╚══════╝░╚════╝░░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝
]],
        },
        sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
        },
    },
    gitbrowse = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = { enabled = true },
    toggle = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },
})
EOF
