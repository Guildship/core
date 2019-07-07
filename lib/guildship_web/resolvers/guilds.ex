defmodule GuildshipWeb.Resolvers.Guilds do
  alias Guildship.Guilds

  def guilds(_, args, %{context: %{current_user: current_user}}) do
    with :ok <- Bodyguard.permit(Guilds, :get_guilds, current_user) do
      Absinthe.Relay.Connection.from_query(
        Guilds.Guild,
        &Guildship.Repo.all/1,
        args
      )
    end
  end
end
