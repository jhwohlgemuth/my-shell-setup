FROM debian:stable-slim
RUN apt-get update && apt-get install --no-install-recommends --yes \
    ca-certificates \
    neovim \
    curl \
    git \
    nodejs \
    npm \
    unzip \
    && rm -rf /var/lib/apt/lists/*
RUN useradd --create-home --shell /bin/bash testuser
COPY .config/nvim /home/testuser/.config/nvim
RUN find /home/testuser/.config/nvim -type f -exec sed -i 's/\r$//' {} +
RUN chown -R testuser:testuser /home/testuser/.config
USER testuser
WORKDIR /home/testuser
RUN nvim --headless "+PlugInstall --sync" +qa
RUN nvim --headless "+lua for name, plugin in pairs(vim.g.plugs) do if vim.fn.isdirectory(plugin.dir) == 0 then print('Missing plugin: ' .. name); vim.cmd('cquit') end end; if vim.v.errmsg ~= '' then print(vim.v.errmsg); vim.cmd('cquit') end" +qa
RUN nvim --headless "+lua Snacks.picker.files(); vim.wait(1000); if vim.v.errmsg ~= '' then print(vim.v.errmsg); vim.cmd('cquit') end" +qa
CMD ["nvim"]
