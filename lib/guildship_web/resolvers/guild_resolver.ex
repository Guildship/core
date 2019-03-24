defmodule GuildshipWeb.Resolvers.GuildResolver do
  alias Guildship.{Accounts, Guilds}

  def create_guild(_root, args, %{context: %{current_user: user}}) do
    Guilds.create_guild(args |> Map.put(:user_id, user.id))
  end

  def get_guilds(_root, _args, _info) do
    case Guilds.get_guilds() do
      [] -> {:ok, []}
      guild_list when is_list(guild_list) -> {:ok, guild_list}
      error -> {:error, error}
    end
  end

  def get_guild_by_id(_root, %{guild_id: guild_id}, _info) do
    case Guilds.get_guild_by_id(guild_id) do
      %Guilds.Guild{} = guild -> {:ok, guild}
      _ -> {:error, :not_found}
    end
  end

  def get_forum_thread_by_id(_root, %{forum_thread_id: forum_thread_id}, _info) do
    case Guilds.get_forum_thread_by_id(forum_thread_id) do
      %Guilds.ForumThread{} = forum_thread -> {:ok, forum_thread}
      _ -> {:error, :not_found}
    end
  end

  def create_forum_category(_root, params, _info) do
    Guilds.create_forum_category(params)
  end

  def create_forum_thread(_root, params, %{
        context: %{current_user: %Accounts.User{id: user_id}}
      }) do
    Guilds.create_forum_thread(params |> Map.put(:user_id, user_id))
  end

  def create_forum_thread_reply(_root, params, _info) do
    Guilds.create_forum_thread_reply(params)
  end
end
