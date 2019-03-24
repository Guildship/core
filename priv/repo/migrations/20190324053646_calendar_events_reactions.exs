defmodule Guildship.Repo.Migrations.CalendarEventsReactions do
  use Ecto.Migration

  def change do
    create table("calendar_events_reactions") do
      add :reactionable_id, references(:calendar_events), null: false
      add :user_id, references(:users), null: false

      timestamps(inserted_at: :created_at)
    end
  end
end
