# Harpoon

Harpoon is an http client framework built on top of Tesla that produces clients that are pluggable, behave predictibly, and can easily be mocked. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `harpoon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:harpoon, github: "ironbay/harpoon"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/harpoon>.

## Documentation

Harpoon modules are simply [Tesla](github.com/teamon/tesla) modules.  The only requirement is to specify each function using the `hook` macro and pass in  `client()` to any HTTP calls.

```elixir
defmodule Harpoon.Example do
  use Harpoon

  plug(Harpoon.Response)
  plug(Tesla.Middleware.BaseUrl, "https://jsonplaceholder.typicode.com/")
  plug(Tesla.Middleware.JSON)

  hook todos() do
    get(client(), "/todos")
  end
end
```

Any application referencing this module can inject their own middleware or mock certain functions in the module

```elixir
config :harpoon, %{
  Harpoon.Example => %{
    # Adds middleware to the top
    pre: [Tesla.Middleware.Logger]
    # Adds middleware to the bottom
    post: [],
    # Mock module to use instead
    module: Harpoon.Example.Mock
  },
  # Applies to all Harpoon clients
  :global => %{
  }
}
```

If a mock module is specified, any function with matching arity will be called instead.  If `harpoon_catch/2` is defined it will serve as a catch all for all functions and be passed a function name and list of arguments

```elixir
defmodule Harpoon.Example.Mock do
  require Logger

  def todos() do
    {:ok,
     [
       %{
         "completed" => false,
         "id" => 1,
         "title" => "delectus aut autem",
         "userId" => 1
       },
       %{
         "completed" => true,
         "id" => 2,
         "title" => "quis ut nam facilis et officia qui",
         "userId" => 1
       }
     ]}
  end

  def harpoon_catch(fun, args) do
    Logger.info(inspect({fun, args}))
  end
end

```

## Harpoon Clients

-   [harpoon_twilio](https://github.com/ironbay/harpoon_twilio/)
