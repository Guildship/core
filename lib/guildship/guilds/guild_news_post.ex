defmodule Guildship.Guild.GuildNewsPost do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.{Accounts, Guilds, Components}

  schema "guild_news_posts" do
    field :title, :string
    belongs_to :user, Accounts.User
    belongs_to :guild, Guilds.Guild
    embeds_many :components, Components.Component

    timestamps type: :utc_datetime
  end

  def changeset(%GuildNewsPost{} = guild_news_post, params) do
    guild_news_post
    |> cast(params, [:title, :user_id, :guild_id, :components])
    |> validate_required([:title, :user_id, :guild_id, :components])
  end

  def new(%GuildNewsPost{} = guild_news_post, params) do
    guild_news_post
    |> changeset(params)
  end
end
