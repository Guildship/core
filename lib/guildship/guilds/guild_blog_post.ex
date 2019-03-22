defmodule Guildship.Guilds.GuildBlogPost do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.{Accounts, Guilds}

  schema "guild_blog_posts" do
    field :title, :string
    field :body, :string
    belongs_to :user, Accounts.User
    belongs_to :guild, Guilds.Guild

    timestamps type: :utc_datetime
  end

  def changeset(%GuildBlogPost{} = blog_post, params) do
    blog_post
    |> cast(params, [:title, :user_id, :guild_id, :body])
    |> validate_required([:title, :user_id, :guild_id, :body])
  end

  def new(%GuildBlogPost{} = blog_post, params) do
    blog_post
    |> changeset(params)
  end
end
