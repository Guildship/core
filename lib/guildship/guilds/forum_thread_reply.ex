defmodule Guildship.Guilds.ForumThreadReply do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.{Guilds, Accounts}

  schema "forum_thread_replies" do
    belongs_to :user, Accounts.User
    belongs_to :forum_thread, Guilds.ForumThread
    embeds_many :components, Guildship.Components.Component

    timestamps()
  end

  def changeset(%ForumThreadReply{} = forum_thread_reply, params) do
    forum_thread_reply
    |> cast(params, [:user_id, :forum_thread_id, :components])
    |> validate_required([:user_id, :forum_thread_id, :components])
  end

  def new(%ForumThreadReply{} = forum_thread_reply, params) do
    forum_thread_reply
    |> changeset(params)
  end
end
