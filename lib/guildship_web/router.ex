defmodule GuildshipWeb.Router do
  use GuildshipWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug GuildshipWeb.Context
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug.GraphiQL,
      schema: GuildshipWeb.Schema,
      interface: :playground,
      json_codec: Jason,
      socket: GuildshipWeb.UserSocket,
      pipeline: {ApolloTracing.Pipeline, :plug}
  end
end
