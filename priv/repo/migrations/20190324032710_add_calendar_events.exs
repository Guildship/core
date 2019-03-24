defmodule Guildship.Repo.Migrations.AddCalendarEvents do
  use Ecto.Migration

  def change do
    create table("calendar_events") do
      add :user_id, references(:users), null: false
      add :guild_id, references(:guilds), null: false
      add :title, :string, null: false
      add :description, :text
      add :start_date, :date, null: false
      add :start_time, :time
      add :end_date, :date, null: false
      add :end_time, :time
    end
  end
end
