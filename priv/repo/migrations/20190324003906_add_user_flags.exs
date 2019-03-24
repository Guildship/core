defmodule Guildship.Repo.Migrations.AddUserFlags do
  use Ecto.Migration

  def change do
    create table("users_flags") do
      add :flaggable_id, :integer, null: false

      timestamps(inserted_at: :created_at)
    end

    create index("users_flags", [:flaggable_id])
  end
end
