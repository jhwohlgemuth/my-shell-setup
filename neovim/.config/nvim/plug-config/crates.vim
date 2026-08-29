lua << EOF
local ok, crates = pcall(require, "crates")
if ok then
    crates.setup()
end
EOF
