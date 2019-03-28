defmodule Guildship.Repo.Migrations.ForumThreadPinning do
  use Ecto.Migration

  def change do
    alter table("forum_threads") do
      add :is_pinned, :bool, null: false
    end
  end
end
