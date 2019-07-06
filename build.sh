#!/usr/bin/env bash
export MIX_ENV=prod

# get app name and version from mix.exs
export APP_NAME="$(grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g')"
export APP_VSN="$(grep 'version:' mix.exs | cut -d '"' -f2)"

# remove existing builds
rm -rf "_build"

# Compile app and assets
mix deps.get --only prod
mix compile

# create release
# we don't need to create a tarball because the app will be
# served directly from the build directory
mix distillery.release --env=prod --no-tar

echo "Linking release $APP_NAME:$APP_VSN to _render/"

mix ecto.setup

ln -sf "_build/$MIX_ENV/rel/$APP_NAME" _render
