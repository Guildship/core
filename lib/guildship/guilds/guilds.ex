defmodule Guildship.Guilds do
  import Ecto
  alias __MODULE__
  alias Ecto.Multi

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

  def create_guild(%{user_id: user_id} = params) do
    case Multi.new()
         |> Multi.insert(:guild, Guild.new(%Guild{}, params))
         |> Multi.merge(fn %{guild: guild} ->
           Multi.new()
           |> Multi.insert(
             :first_membership,
             # When creating a guild, the creator becomes an admin
             Membership.new(%Membership{role: "admin"}, %{
               guild_id: guild.id,
               user_id: user_id
             })
           )
         end)
         |> Repo.transaction() do
      {:ok, %{guild: %Guild{} = guild, first_membership: %Membership{}}} ->
        {:ok, guild}

      {:error, error} ->
        {:error, error}
    end
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
    case Multi.new()
         |> Multi.insert(:forum_thread, ForumThread.new(%ForumThread{}, params))
         |> Multi.merge(fn %{forum_thread: forum_thread} ->
           Multi.new()
           |> Multi.insert(
             :forum_thread_reply,
             ForumThreadReply.new(%ForumThreadReply{}, %{
               forum_thread_id: forum_thread.id,
               user_id: forum_thread.user_id,
               body: params.body
             })
           )
         end)
         |> Repo.transaction() do
      {:ok, %{forum_thread: %ForumThread{} = forum_thread}} ->
        {:ok, forum_thread}

      {:error, error} ->
        {:error, error}
    end
  end

  def pin_forum_thread(%ForumThread{} = thread) do
    thread
    |> ForumThread.edit(%{is_pinned: true})
    |> Repo.update()
  end

  def lock_forum_thread(%ForumThread{} = thread) do
    thread
    |> ForumThread.edit(%{is_locked: true})
    |> Repo.update()
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

  def change_membership_role(%Membership{} = membership, new_role) do
    membership
    |> Membership.edit(%{
      role: new_role
    })
    |> Repo.update()
  end
end
