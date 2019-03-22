defmodule Guildship.Guilds.GuildNewsPost do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.{Accounts, Guilds}

  schema "guild_news_posts" do
    field :title, :string
    field :body, :string
    belongs_to :user, Accounts.User
    belongs_to :guild, Guilds.Guild

    timestamps type: :utc_datetime
  end

  def changeset(%GuildNewsPost{} = guild_news_post, params) do
    guild_news_post
    |> cast(params, [:title, :user_id, :guild_id, :body])
    |> validate_required([:title, :user_id, :guild_id, :body])
  end

  def new(%GuildNewsPost{} = guild_news_post, params) do
    guild_news_post
    |> changeset(params)
  end
end
