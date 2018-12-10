defmodule Guildship.Guilds.ForumThread do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.{Guilds, Accounts}

  schema "forum_threads" do
    field :title, :string
    belongs_to :user, Accounts.User
    belongs_to :guild, Guilds.Guild
    belongs_to :forum_category, Guilds.ForumCategory
    has_many :forum_thread_replies, Guilds.ForumThreadReply

    timestamps(type: :utc_datetime)
  end

  def changeset(%ForumThread{} = forum_thread, params) do
    forum_thread
    |> cast(params, [:title, :user_id, :guild_id, :forum_category_id])
    |> validate_required([:title, :user_id, :guild_id, :forum_category_id])
  end

  def new(%ForumThread{} = forum_thread, params) do
    forum_thread
    |> changeset(params)
  end
end
