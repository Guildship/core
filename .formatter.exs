[
  inputs: ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}", "priv/*/seeds.exs"],
  import_deps: [:phoenix, :ecto, :absinthe],
  subdirectories: ["priv/*/migrations"],
  line_length: 80
]
