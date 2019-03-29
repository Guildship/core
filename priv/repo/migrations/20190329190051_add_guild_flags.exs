defmodule Guildship.Repo.Migrations.AddGuildFlags do
  use Ecto.Migration

  def change do
    create table("guilds_flags") do
      add :flaggable_id, references(:guilds), null: false

      timestamps(inserted_at: :created_at)
    end
  end
end
