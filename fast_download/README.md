# FastDownload

An Elixir package for downloading NEO blockchain blocks through multiple parallel process.
Download starts with `mix fast_download.run n` where `n` is the number of process.
The downloaded data is streamed into a JSON file in the root of the package location

Main seeds can be defined in FastDownload.HttpCalls module

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fast_download` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:fast_download, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/fast_download](https://hexdocs.pm/fast_download).
