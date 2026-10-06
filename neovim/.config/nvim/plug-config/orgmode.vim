lua << EOF
local ok, orgmode = pcall(require, "orgmode")
if ok then
    orgmode.setup({
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
    })
end
EOF
