defmodule Guildship.Repo.Migrations.CreateGuildFeatures do
  use Ecto.Migration

  def change do
    create table("forum_categories") do
      add(:name, :string, null: false)
      add(:guild_id, references(:guilds), null: false)

      timestamps(inserted_at: :created_at)
    end

    create table("forum_threads") do
      add(:title, :string, null: false)
      add(:user_id, references(:users), null: false)
      add(:forum_category_id, references(:forum_categories), null: false)

      timestamps(inserted_at: :created_at)
    end

    create table("forum_thread_replies") do
      add(:user_id, references(:users), null: false)
      add(:forum_thread_id, references(:forum_threads), null: false)
      add(:body, :text, null: false)

      timestamps(inserted_at: :created_at)
    end

    create table("guild_blog_posts") do
      add(:title, :string, null: false)
      add(:user_id, references(:users), null: false)
      add(:guild_id, references(:guilds), null: false)
      add(:body, :text, null: false)

      timestamps(inserted_at: :created_at)
    end
  end
end
