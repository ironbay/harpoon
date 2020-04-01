defmodule Harpoon.Config do
  def for_module(), do: for_module(:global)

  def for_module(mod) do
    :harpoon
    |> Application.get_env(mod, %{})
    |> defaults()
  end

  def defaults(input) do
    Map.merge(
      %{pre: [], post: [], adapter: nil},
      input
    )
  end

  def put(mod, cfg) do
    Application.put_env(:harpoon, mod, cfg)
  end

  def put_pre(middleware), do: put_pre(:global, middleware)

  def put_pre(mod, middleware) do
    result = for_module(mod)
    put(mod, %{result | pre: Enum.uniq([middleware | result.pre])})
  end

  def put_post(middleware), do: put_pre(:global, middleware)

  def put_post(mod, middleware) do
    result = for_module(mod)
    put(mod, %{result | pre: Enum.uniq([middleware | result.pre])})
  end
end
