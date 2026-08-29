lua << EOF
local ok, autopairs = pcall(require, "nvim-autopairs")
if not ok then
    return
end

autopairs.setup({
    -- CoC owns the completion-aware Enter mapping.
    map_cr = false,
    disable_filetype = { "snacks_picker_input", "TelescopePrompt", "spectre_panel" },
})
EOF
