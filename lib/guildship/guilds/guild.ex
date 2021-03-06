defmodule Guildship.Guilds.Guild do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.Support
  alias Guildship.Guilds.{Membership, ForumCategory}

  schema "guilds" do
    field :user_id, :integer, virtual: true
    field :display_name, :string
    has_many :forum_categories, ForumCategory, on_delete: :delete_all
    has_many :guild_memberships, Membership, on_delete: :delete_all
    has_many :flags, {"guilds_flags", Support.Flag}, foreign_key: :flaggable_id

    timestamps()
  end

  def changeset(%Guild{} = guild, params) do
    guild
    |> cast(params, [:display_name, :user_id])
  end

  def new(%Guild{} = guild, params) do
    guild
    |> changeset(params)
    |> validate_required([:display_name, :user_id])
    |> validate_length(:display_name, min: 3, max: 24)
  end
end
