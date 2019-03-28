defmodule Guildship.Guilds.Reaction do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.Accounts

  schema "abstract table: reactions" do
    field :reactionable_id, :integer
    field :emoji_name, :string
    belongs_to :user, Accounts.User

    timestamps()
  end

  def changeset(%Reaction{} = reaction, params) do
    reaction
    |> cast(params, [:reactionable_id, :user_id, :emoji_name])
    |> validate_required([:reactionable_id, :user_id, :emoji_name])
    |> unique_constraint(:emoji_name,
      name: "guild_blog_posts_reactions_reactionable_id_user_id_emoji_name_i"
    )
    |> unique_constraint(:emoji_name,
      name: "forum_thread_replies_reactions_reactionable_id_user_id_emoji_na"
    )
    |> unique_constraint(:emoji_name,
      name: "calendar_events_reactions_reactionable_id_user_id_emoji_name_in"
    )
  end

  def new(%Reaction{} = reaction, params) do
    reaction
    |> changeset(params)
  end
end
