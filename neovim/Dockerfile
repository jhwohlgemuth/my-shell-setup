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
RUN chown -R testuser:testuser /home/testuser/.config
USER testuser
WORKDIR /home/testuser
RUN nvim --headless "+PlugInstall" +qa || true
CMD ["nvim"]
