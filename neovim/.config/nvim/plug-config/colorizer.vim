lua << EOF
local ok, colorizer = pcall(require, "colorizer")
if ok then
    colorizer.setup()
end
EOF
