defmodule GuildshipWeb.PageController do
  use GuildshipWeb, :controller

  def health(conn, _params) do
    conn
    |> text("healthy")
  end
end
