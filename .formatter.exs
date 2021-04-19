# Used by "mix format"
[
  import_deps: [:ecto],
  inputs: [
    "{mix,.formatter}.exs",
    "*.{ex,exs}",
    "priv/*/seeds.exs",
    "{config,lib,test}/**/*.{ex,exs}"
  ],
  subdirectories: ["priv/*/migrations"]
]
