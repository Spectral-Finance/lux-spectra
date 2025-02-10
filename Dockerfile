FROM elixir:1.18.1

# Build Args
ARG PHOENIX_VERSION=1.7.18
ARG NODE_VERSION=20.10.0
ARG MIX_ENV=dev

# Environment variables that should be available at runtime
ENV MIX_ENV=${MIX_ENV} \
    LANG=C.UTF-8

# Dependencies
RUN apt update \
  && apt upgrade -y \
  && apt install -y bash curl git build-essential inotify-tools

# Setup SSH for private dependencies
RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts

# Create app directory
WORKDIR /app

# Setup hex/rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy dependency files
COPY mix.exs mix.lock ./

# Get dependencies
RUN --mount=type=ssh mix do deps.clean --all, deps.get

# Copy the rest of the application code
COPY . .

# App Port
EXPOSE 4000

# Start Phoenix with auto-reload enabled
CMD ["mix", "phx.server"]