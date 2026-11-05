FROM debian:stable-slim AS configured
ARG NVIM_VERSION=v0.12.6
ARG NVIM_AMD64_SHA256=474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87
ARG NVIM_ARM64_SHA256=8f1f64a0bdb97247034038c3823c6cbad5bdf9ecd5751b85494b71c3ee04c815
RUN apt-get update && apt-get install --no-install-recommends --yes \
    ca-certificates \
    curl \
    git \
    nodejs \
    npm \
    unzip \
    && case "$(dpkg --print-architecture)" in \
        amd64) NVIM_ARCH=x86_64; NVIM_SHA256="${NVIM_AMD64_SHA256}" ;; \
        arm64) NVIM_ARCH=arm64; NVIM_SHA256="${NVIM_ARM64_SHA256}" ;; \
        *) echo "Unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
    esac \
    && curl --fail --location --output /tmp/nvim.tar.gz \
        "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-${NVIM_ARCH}.tar.gz" \
    && echo "${NVIM_SHA256}  /tmp/nvim.tar.gz" | sha256sum --check - \
    && tar --directory /opt --extract --gzip --file /tmp/nvim.tar.gz \
    && ln --symbolic "/opt/nvim-linux-${NVIM_ARCH}/bin/nvim" /usr/local/bin/nvim \
    && nvim --version | grep --fixed-strings "NVIM ${NVIM_VERSION}" \
    && rm -rf /tmp/nvim.tar.gz /var/lib/apt/lists/*
RUN useradd --create-home --shell /bin/bash testuser
COPY .config/nvim /home/testuser/.config/nvim
RUN find /home/testuser/.config/nvim -type f -exec sed -i 's/\r$//' {} +
RUN chown -R testuser:testuser /home/testuser/.config
USER testuser
WORKDIR /home/testuser

FROM configured AS plugin-setup
RUN nvim --headless --cmd 'let g:bootstrap_plugins = 1' "+PlugInstall --sync" +qa

FROM plugin-setup AS pinned-subset
RUN set -eu; \
    plugin_root="${HOME}/.local/share/nvim/plugged"; \
    test -s "${HOME}/.local/share/nvim/site/autoload/plug.vim"; \
    for pin in \
        "coc.nvim:5950d87e3bf9adcc6737526cc065b9c054b95f25" \
        "codeium.vim:c5c027c31ba8afd38a718c650f363437fbaeb4bc" \
        "plenary.nvim:74b06c6c75e4eeb3108ec01852001636d85a932b" \
        "codecompanion.nvim:9cc3c1352181253d6a65c709431f30a90a45eb05" \
        "fzf:99bfd5aa0f66133d7dcfbf18f8044eb765f04649" \
        "fzf.vim:023de3c0e158ff9c2b0992175af10be97c2f2158" \
        "fzf-preview.vim:933836744ad5907653bc903d027eb1a08ed95811" \
        "vim-sneak:feea86adcfbf8e6b5e71fdd5f4f5736fd8819fdb" \
        "vim-choosewin:839da609d9b811370216bdd9d4512ec2d0ac8644" \
        "vim-commentary:64a654ef4a20db1727938338310209b6a63f60c9" \
        "vim-surround:3d188ed2113431cf8dac77be61b842acb64433d9" \
        "nvim-autopairs:3172f40c16563db871a58f20d205c710ad782311" \
        "vim-visual-multi:a6975e7c1ee157615bbc80fc25e4392f71c344d4" \
        "vim-closetag:d0a562f8bdb107a50595aefe53b1a690460c3822" \
        "tabular:12437cd1b53488e24936ec4b091c9324cafee311" \
        "undotree:6fa6b57cda8459e1e4b2ca34df702f55242f4e4d"; do \
        plugin="${pin%%:*}"; \
        expected="${pin#*:}"; \
        actual="$(git -C "${plugin_root}/${plugin}" rev-parse HEAD)"; \
        test "${actual}" = "${expected}"; \
    done; \
    runtime_path=""; \
    for plugin in \
        coc.nvim codeium.vim plenary.nvim codecompanion.nvim \
        fzf fzf.vim fzf-preview.vim vim-sneak vim-choosewin \
        vim-commentary vim-surround nvim-autopairs vim-visual-multi \
        vim-closetag tabular undotree; do \
        runtime_path="${runtime_path},${plugin_root}/${plugin}"; \
    done; \
    nvim --headless -u NONE \
        --cmd "set runtimepath^=${runtime_path#,}" \
        "+runtime! plugin/**/*.vim" \
        "+runtime! plugin/**/*.lua" \
        "+lua assert(require('plenary.path')); assert(require('nvim-autopairs')); assert(require('codecompanion')); if vim.v.errmsg ~= '' then print(vim.v.errmsg); vim.cmd('cquit') end" \
        +qa

FROM pinned-subset
RUN nvim --headless "+lua for name, plugin in pairs(vim.g.plugs) do if vim.fn.isdirectory(plugin.dir) == 0 then print('Missing plugin: ' .. name); vim.cmd('cquit') end end; if vim.v.errmsg ~= '' then print(vim.v.errmsg); vim.cmd('cquit') end" +qa
RUN nvim --headless "+lua Snacks.picker.files(); vim.wait(1000); if vim.v.errmsg ~= '' then print(vim.v.errmsg); vim.cmd('cquit') end" +qa
CMD ["nvim"]
