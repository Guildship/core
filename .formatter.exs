[
  inputs: [
    "*.{ex,exs}",
    "{config,lib,test,rel}/**/*.{ex,exs}",
    "priv/*/seeds.exs"
  ],
  locals_without_parens: [resolve_safe: 1],
  import_deps: [:phoenix, :ecto, :absinthe, :distillery],
  subdirectories: ["priv/*/migrations"],
  line_length: 80
]
