defmodule GuildshipWeb.Schema.Middleware.Authenticate do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    with %{current_user: _user} <- resolution.context do
      resolution
    else
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "unauthenticated"})
    end
  end
end
