defmodule Harpoon.Example do
  use Harpoon
  import Fisherman

  plug(Harpoon.Response)
  plug(Tesla.Middleware.BaseUrl, "https://jsonplaceholder.typicode.com/")
  plug(Tesla.Middleware.JSON)

  hook todos() do
    get(client(), "/todos")
  end
end

defmodule Harpoon.Example.Override do
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
