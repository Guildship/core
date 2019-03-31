defmodule GuildshipWeb.Router do
  use GuildshipWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end
end
