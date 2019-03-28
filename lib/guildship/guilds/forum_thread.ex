defmodule Guildship.Guilds.ForumThread do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.{Guilds, Accounts}

  schema "forum_threads" do
    field :title, :string
    field :is_pinned, :boolean, default: false
    belongs_to :user, Accounts.User
    belongs_to :forum_category, Guilds.ForumCategory
    has_many :forum_thread_replies, Guilds.ForumThreadReply

    timestamps()
  end

  def changeset(%ForumThread{} = forum_thread, params) do
    forum_thread
    |> cast(params, [:title, :user_id, :forum_category_id, :is_pinned])
    |> validate_required([:title, :user_id, :forum_category_id])
  end

  def new(%ForumThread{} = forum_thread, params) do
    forum_thread
    |> changeset(params)
  end

  def edit(%ForumThread{} = forum_thread, params) do
    forum_thread
    |> changeset(params)
  end
end
