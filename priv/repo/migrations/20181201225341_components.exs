defmodule Guildship.Repo.Migrations.Components do
  use Ecto.Migration

  def change do
    create table("forum_categories") do
      add :name, :string, null: false
      add :guild_id, references(:guilds), null: false

      timestamps()
    end

    create table("forum_threads") do
      add :title, :string, null: false
      add :user_id, references(:users), null: false
      add :guild_id, references(:guilds), null: false
      add :forum_category_id, references(:forum_categories), null: false

      timestamps()
    end

    create table("forum_thread_replies") do
      add :user_id, references(:users), null: false
      add :forum_thread_id, references(:forum_threads), null: false
      add :components, :jsonb, default: "[]", null: false

      timestamps()
    end

    create table("guild_news_posts") do
      add :title, :string, null: false
      add :user_id, references(:users), null: false
      add :guild_id, references(:guilds), null: false
      add :components, :jsonb, default: "[]", null: false

      timestamps()
    end
  end
end
