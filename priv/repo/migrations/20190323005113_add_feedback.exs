defmodule Guildship.Repo.Migrations.AddFeedback do
  use Ecto.Migration

  def change do
    create table("feedback") do
      add(:message, :text, null: false)
      add(:user_id, references(:users))

      timestamps(inserted_at: :created_at)
    end
  end
end
