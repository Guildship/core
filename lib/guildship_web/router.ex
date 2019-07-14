defmodule GuildshipWeb.Router do
  use GuildshipWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :log do
    plug Plug.Logger
  end

  scope "/health" do
    get "/", GuildshipWeb.PageController, :health
  end

  scope "/" do
    pipe_through :log

    forward "/api", Absinthe.Plug,
      json_codec: Phoenix.json_library(),
      schema: GuildshipWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: GuildshipWeb.Schema,
      json_codec: Phoenix.json_library(),
      interface: :playground
  end
end
