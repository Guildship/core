defmodule Guildship.Repo.Migrations.ForumThreadRepliesReactions do
  use Ecto.Migration

  def change do
    create table("forum_thread_replies_reactions") do
      add :reactionable_id, references(:forum_thread_replies), null: false
      add :user_id, references(:users), null: false

      timestamps(inserted_at: :created_at)
    end
  end
end
