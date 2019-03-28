defmodule Guildship.Repo.Migrations.ForumThreadLocking do
  use Ecto.Migration

  def change do
    alter table("forum_threads") do
      add :is_locked, :bool, null: false
    end
  end
end
