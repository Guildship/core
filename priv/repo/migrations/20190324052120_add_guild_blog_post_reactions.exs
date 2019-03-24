defmodule Guildship.Repo.Migrations.AddGuildBlogPostReactions do
  use Ecto.Migration

  def change do
    create table("guild_blog_posts_reactions") do
      add :reactionable_id, references(:guild_blog_posts), null: false
      add :user_id, references(:users), null: false
    end
  end
end
