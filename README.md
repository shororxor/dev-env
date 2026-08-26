# Development Environment Setup

Personal development environment configuration, including dotfiles for Neovim, Vim, Tmux, Bash, and Dockerfiles for development containers. This setup is designed to provide a smooth, consistent workflow while improving efficiency, productivity, and the overall development experience.

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
| `base-dev-vim` | Ubuntu 22.04 / 24.04 / 26.04| `base-dev` + Vim/Neovim |

### Build locally

```bash
docker build --tag shororxor/base-dev-vim:ubuntu-26.04 \
             --file docker-images/base-dev-vim:ubuntu-26.04.Dockerfile \
             --build-arg USERNAME=$USER \
             /
```

### Publish to Docker Hub

```bash
docker login
docker tag shororxor/base-dev-vim:ubuntu-26.04 shororxor/base-dev-vim:ubuntu-26.04
docker push shororxor/base-dev-vim:ubuntu-26.04
```

### Pull from Docker Hub
```
docker pull shororxor/base-dev-vim:ubuntu-26.04
```

### Spawn a container to test image
```
docker run -it --name <container-name> \
           -v <host-pwd>:<container-pwd> \
           -p <port>:<port> \
           <docker-image>
```
