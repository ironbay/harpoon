defmodule Harpoon do
  defmacro __using__(_opts) do
    quote do
      use Tesla
      require Harpoon
      import Harpoon

      def client() do
        {pre, post} = Harpoon.middleware(__MODULE__)
        adapter = Harpoon.adapter(__MODULE__)
        Tesla.Builder.client(pre, post, adapter)
      end
    end
  end

  defmacro hook({name, _, args}, do: body) do
    arity = Enum.count(args)

    quote do
      def unquote(name)(unquote_splicing(args)) do
        mod = Harpoon.Config.for_module(__MODULE__).module

        cond do
          mod && Harpoon.exported?(mod, unquote(name), unquote(arity)) ->
            apply(mod, unquote(name), unquote(args))

          mod && Harpoon.exported?(mod, :harpoon_catch, 2) ->
            apply(mod, :harpoon_catch, [unquote(name), unquote(args)])

          true ->
            unquote(body)
        end
      end
    end
  end

  def exported?(mod, fun, arity) do
    mod.__info__(:functions)
    |> Enum.member?({fun, arity})
  end

  def middleware(mod) do
    %{pre: global_pre, post: global_post} = Harpoon.Config.for_module()
    %{pre: module_pre, post: module_post} = Harpoon.Config.for_module(mod)
    {global_pre ++ module_pre, global_post ++ module_post}
  end

  def adapter(mod) do
    Harpoon.Config.for_module().adapter || Harpoon.Config.for_module(mod).adapter
  end
end

defmodule Harpoon.Response do
  @spec call(any, maybe_improper_list, any) :: any
  def call(env, next, _options) do
    env
    |> Tesla.run(next)
    |> case do
      {:ok, %{status: status, body: body}} when status >= 200 and status < 300 ->
        {:ok, body}

      {:ok, %{status: status, body: body}}
      when status >= 400 and status < 500 ->
        {:error, body}

      result ->
        result
    end
  end
end
