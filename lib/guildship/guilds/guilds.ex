defmodule Guildship.Guilds do
  import Ecto
  alias __MODULE__

  alias Guilds.{
    Guild,
    ForumCategory,
    ForumThread,
    ForumThreadReply,
    GuildBlogPost,
    CalendarEvent,
    Membership
  }

  alias Guildship.Repo

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  def create_guild(params) do
    %Guild{}
    |> Guild.new(params)
    |> Repo.insert()
  end

  def get_guilds() do
    Repo.all(Guild)
  end

  def get_guild_by_id(id) do
    Repo.get(Guild, id)
  end

  def get_forum_thread_by_id(id) do
    Repo.get(ForumThread, id)
  end

  def create_forum_category(params) do
    %ForumCategory{}
    |> ForumCategory.new(params)
    |> Repo.insert()
  end

  def create_forum_thread(params) do
    %ForumThread{}
    |> ForumThread.new(params)
    |> Repo.insert()
  end

  def create_forum_thread_reply(params) do
    %ForumThreadReply{}
    |> ForumThreadReply.new(params)
    |> Repo.insert()
  end

  def create_guild_blog_post(params) do
    %GuildBlogPost{}
    |> GuildBlogPost.new(params)
    |> Repo.insert()
  end

  def create_calendar_event(params) do
    %CalendarEvent{}
    |> CalendarEvent.new(params)
    |> Repo.insert()
  end

  def add_reaction(resource, %{user_id: user_id}) do
    Repo.insert(build_assoc(resource, :reactions, user_id: user_id))
  end

  def join_guild(params) do
    # You will always default to member when joining a guild
    %Membership{role: "member"}
    |> Membership.new(params)
    |> Repo.insert()
  end

  def leave_guild(%Membership{} = membership) do
    membership
    |> Repo.delete()
  end
end
