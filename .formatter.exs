[
  inputs: [
    "*.{ex,exs}",
    "{config,lib,test,rel}/**/*.{ex,exs}",
    "priv/*/seeds.exs"
  ],
  import_deps: [:phoenix, :ecto, :absinthe, :distillery],
  subdirectories: ["priv/*/migrations"],
  line_length: 80
]
