defmodule GuildshipWeb.Resolvers.Guilds do
  alias Guildship.Guilds

  def guilds(_, args, _) do
    with true do
      Absinthe.Relay.Connection.from_query(
        Guilds.Guild,
        &Guildship.Repo.all/1,
        args
      )
    end
  end
end
