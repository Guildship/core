defmodule Guildship.Repo.Migrations.AddUserFlags do
  use Ecto.Migration

  def change do
    create table("users_flags") do
      add :flaggable_id, references(:users), null: false

      timestamps(inserted_at: :created_at)
    end
  end
end
