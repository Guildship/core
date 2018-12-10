defmodule Guildship.Repo.Migrations.CreateGuilds do
  use Ecto.Migration

  def change do
    create table("guilds") do
      add :display_name, :string, null: false
      add :components, :jsonb, default: "[]", null: false

      timestamps()
    end
  end
end
