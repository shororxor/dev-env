# Development Environment Setup

Personal dev environment configuration, including dotfiles for Neovim, Vim, Tmux, Bash, and Dockerfiles for dev containers.

## Quick Start

Clone and symlink dotfiles:

```bash
git clone git@github.com:shororxor/dev-env.git
cd dev-env && ./setup.sh
```

Pull pre-built Docker images:

```bash
docker pull shororxor/base-dev-vim:ubuntu-24.04
docker pull shororxor/base-dev:ubuntu-24.04
```

## Docker Images

Images are built from `docker-images/*.Dockerfile`. Two flavours are available:

| Image | Base | Description |
|-------|------|-------------|
| `base-dev` | Ubuntu 22.04 / 24.04 | Common CLI tools |
| `base-dev-vim` | Ubuntu 22.04 / 24.04 | `base-dev` + Vim/Neovim |

### Build locally

```bash
docker build -t base-dev:ubuntu-24.04 -f docker-images/base-dev:ubuntu-24.04.Dockerfile ~/
```

### Publish to Docker Hub

```bash
docker login
docker tag base-dev:ubuntu-24.04 shororxor/base-dev:ubuntu-24.04
docker push shororxor/base-dev:ubuntu-24.04
```