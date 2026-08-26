FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV DISPLAY=:0

# install common cli tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    procps \
    curl \
    wget \
    file \
    git \
    sudo \
    locales \
    ca-certificates \
    unzip \
    zip \
    ripgrep \
    fd-find \
    bash \
    xsel \
    xclip \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Create user and workspace
ARG USERNAME
RUN useradd -ms /bin/bash ${USERNAME} \
    && usermod -aG sudo ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USERNAME}
USER ${USERNAME}
ENV HOME="/home/${USERNAME}"
WORKDIR ${HOME}

# Install homebrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

# Install Cargo/Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="${HOME}/.cargo/bin:${PATH}"

# Intall homebrew CLI tools
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
RUN brew install vim
RUN brew install neovim
RUN brew install tree-sitter
RUN brew install tree-sitter-cli
RUN brew install lazygit
RUN brew install opencode
RUN brew install tmux

# Install oh-my-posh
RUN grep -q '\.local/bin' ~/.bashrc 2>/dev/null || echo 'export PATH="${HOME}/.local/bin:${PATH}"' >> ~/.bashrc
RUN export PATH="${HOME}/.local/bin:${PATH}"

RUN curl -fsSL https://ohmyposh.dev/install.sh | bash -s

RUN grep -q 'oh-my-posh init bash' ~/.bashrc 2>/dev/null || echo 'eval "$(oh-my-posh init bash --config ${HOME}/.config/omp/custom_theme.json)"' >> ~/.bashrc
RUN eval "$(oh-my-posh init bash --config ${HOME}/.config/omp/custome_theme.json)"

# Install fzf
RUN if [ ! -d "${HOME}/.fzf" ]; then \
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"; \
else \
    git -C "${HOME}/.fzf" pull; \
fi

RUN ~/.fzf/install --all

# Install more CLI tools
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    pkg-config \
    libssl-dev \
    && sudo rm -rf /var/lib/apt/lists/*

CMD ["bash"]
