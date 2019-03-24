defmodule Guildship.Repo.Migrations.AddFlags do
  use Ecto.Migration

  def change do
    create table("forum_thread_replies_flags") do
      add :flaggable_id, references(:forum_thread_replies), null: false

      timestamps(inserted_at: :created_at)
    end
  end
end
