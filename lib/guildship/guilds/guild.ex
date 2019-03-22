defmodule Guildship.Guilds.Guild do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.Guilds.ForumCategory
  alias Guildship.Components.Component

  schema "guilds" do
    field :display_name, :string
    has_many :forum_categories, ForumCategory, on_delete: :delete_all
    embeds_many :components, Component

    timestamps()
  end

  def changeset(%Guild{} = guild, params) do
    guild
    |> cast(params, [:display_name])
    |> validate_required([:display_name])
    |> validate_length(:display_name, min: 3, max: 24)
  end

  def new(%Guild{} = guild, params) do
    guild
    |> changeset(params)
  end
end
