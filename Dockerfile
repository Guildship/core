### Backend

FROM elixir:1.9-alpine AS backend

RUN mix local.hex --force && mix local.rebar --force

WORKDIR /app

ENV MIX_ENV prod

# Copy required files for compilation
COPY ./mix.* ./
COPY config config
COPY priv priv

# Compile dependencies
RUN mix do deps.get, deps.compile

### Packager

FROM backend as packager

COPY . /app

RUN mix release

### RELEASE

FROM alpine:3.9

# We need bash and openssl for Phoenix
RUN apk upgrade --no-cache && \
  apk add --no-cache bash libressl libssl1.1

USER root

ENV MIX_ENV prod

WORKDIR /app

COPY --from=packager /app/_build/prod/rel/guildship .

ENTRYPOINT [ "./bin/guildship" ]
