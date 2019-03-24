defmodule Guildship.Repo.Migrations.AddGuildBlogPostFlags do
  use Ecto.Migration

  def change do
    create table("guild_blog_posts_flags") do
      add :flaggable_id, references(:guild_blog_posts), null: false

      timestamps(inserted_at: :created_at)
    end
  end
end
