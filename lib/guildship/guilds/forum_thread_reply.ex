defmodule Guildship.Guilds.ForumThreadReply do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.{Guilds, Accounts}

  schema "forum_thread_replies" do
    field :body, :string
    belongs_to :user, Accounts.User
    belongs_to :forum_thread, Guilds.ForumThread

    timestamps()
  end

  def changeset(%ForumThreadReply{} = forum_thread_reply, params) do
    forum_thread_reply
    |> cast(params, [:user_id, :forum_thread_id, :body])
    |> validate_required([:user_id, :forum_thread_id, :body])
  end

  def new(%ForumThreadReply{} = forum_thread_reply, params) do
    forum_thread_reply
    |> changeset(params)
  end
end
