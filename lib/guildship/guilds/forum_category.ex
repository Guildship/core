defmodule Guildship.Guilds.ForumCategory do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.Guilds

  schema "forum_categories" do
    field :name, :string
    belongs_to :guild, Guilds.Guild
    has_many :forum_threads, Guilds.ForumThread, on_delete: :delete_all

    timestamps()
  end

  def changeset(%ForumCategory{} = forum_category, params) do
    forum_category
    |> cast(params, [:name, :guild_id])
    |> validate_required([:name, :guild_id])
  end

  def new(%ForumCategory{} = forum_category, params) do
    forum_category
    |> changeset(params)
  end

  def edit(%ForumCategory{} = forum_category, params) do
    forum_category
    |> changeset(params)
  end
end
