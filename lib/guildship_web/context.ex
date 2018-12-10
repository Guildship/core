defmodule GuildshipWeb.Context do
  @behaviour Plug
  import Plug.Conn
  alias Guildship.Accounts.User

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, data} <- GuildshipWeb.Authentication.verify(token),
         %User{} = user <- get_user(data) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end

  defp get_user(%{id: id}) do
    Guildship.Accounts.get_user_by_id(id)
  end
end
