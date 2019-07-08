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

  def guilds(_, _, _) do
    {:error, "You must be logged in!"}
  end

  def join_guild(_, %{guild_id: guild_id}, %{
        context: %{current_user: current_user}
      }) do
    case Guildship.Guilds.join_guild(%{
           user_id: current_user.id,
           guild_id: guild_id
         }) do
      {:ok, guild_membership} ->
        {:ok,
         %{
           guild_membership: guild_membership
         }}

      err ->
        err
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
