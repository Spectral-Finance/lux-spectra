FROM elixir:1.18.1

# Build Args
ARG PHOENIX_VERSION=1.7.18
ARG NODE_VERSION=20.10.0

# Dependencies
RUN apt update \
  && apt upgrade -y \
  && apt install -y bash curl git build-essential inotify-tools

# Setup SSH for private dependencies
RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts

# First create the directories (everything under /app)
RUN mkdir -p /opt/build \
    && mkdir -p /opt/build/_build \
    && mkdir -p /opt/build/deps \
    && mkdir -p /opt/build/assets

# Switch to the work dir
WORKDIR /opt/build

# Copy in the base mixfiles
COPY mix.exs mix.lock /opt/build/

# Setup hex/rebar
RUN mix do local.rebar --force, local.hex --force

# Copy in the directories
COPY config /opt/build/config
COPY assets /opt/build/assets

WORKDIR /opt/build

# Copy the app source code and files needed to build the release.
COPY lib/ ./lib
COPY priv/ ./priv/
COPY mix.exs ./mix.exs

# Get dependencies
RUN --mount=type=ssh mix do deps.clean --all, deps.get, deps.compile

RUN mix compile

# App Port
EXPOSE 4000

# Default Command
CMD ["mix", "phx.server"]