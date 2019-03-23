defmodule Guildship.Repo.Migrations.AddFeedback do
  use Ecto.Migration

  def change do
    create table("feedback") do
      add :message, :text, null: false
    end
  end
end
