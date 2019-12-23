defmodule Harpoon.Middleware.Sample do
  @behaviour Tesla.Middleware
  require Logger

  def call(env, next, _options) do
    Logger.info("Harpoon sample middleware")
    Tesla.run(env, next)
  end
end
