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

  def create_guild(_, args, %{context: %{current_user: current_user}}) do
    case Bodyguard.permit(Guilds, :create_guild, current_user) do
      :ok ->
        {:ok, guild} =
          Guilds.create_guild(%{
            user_id: current_user.id,
            display_name: args.display_name
          })

        {:ok,
         %{
           guild: guild
         }}

      err ->
        err
    end
  end

  def create_guild(_, _, _), do: {:error, "Not logged in!"}
end
