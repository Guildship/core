defmodule Guildship.Repo.Migrations.UniqueReactions do
  use Ecto.Migration

  def change do
    create unique_index("forum_thread_replies_reactions", [
             :reactionable_id,
             :user_id,
             :emoji_name
           ])

    create unique_index("calendar_events_reactions", [:reactionable_id, :user_id, :emoji_name])
    create unique_index("guild_blog_posts_reactions", [:reactionable_id, :user_id, :emoji_name])
  end
end
