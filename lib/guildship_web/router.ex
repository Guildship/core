defmodule GuildshipWeb.Router do
  use GuildshipWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  get("/health", GuildshipWeb.PageController, :health)

  forward "/api", Absinthe.Plug,
    json_codec: Phoenix.json_library(),
    schema: GuildshipWeb.Schema

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: GuildshipWeb.Schema,
    json_codec: Phoenix.json_library(),
    interface: :playground
end
