defmodule Guildship.Repo.Migrations.UniqueMembership do
  use Ecto.Migration

  def change do
    create unique_index("guild_memberships", [:user_id, :guild_id])
  end
end
