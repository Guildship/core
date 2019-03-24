defmodule Guildship.Repo.Migrations.GuildMemberships do
  use Ecto.Migration

  def change do
    create table("guild_memberships") do
      add :guild_id, references(:guilds), null: false
      add :user_id, references(:users), null: false
      add :role, :string, null: false

      timestamps(inserted_at: :created_at)
    end
  end
end
