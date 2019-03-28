defmodule Guildship.Repo.Migrations.ReactionEmojiName do
  use Ecto.Migration

  def change do
    alter table("forum_thread_replies_reactions") do
      add :emoji_name, :string, null: false
    end

    alter table("calendar_events_reactions") do
      add :emoji_name, :string, null: false
    end

    alter table("guild_blog_posts_reactions") do
      add :emoji_name, :string, null: false
    end
  end
end
