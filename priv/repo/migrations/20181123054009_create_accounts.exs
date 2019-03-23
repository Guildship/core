defmodule Guildship.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table("users") do
      add :username, :string, null: false

      timestamps(inserted_at: :created_at)
    end

    create unique_index("users", [:username])

    create table("account_credentials") do
      add :user_id, references("users"), null: false
      add :type, :string, null: false
      add :username, :string, null: false
      add :password_hash, :string
    end

    create unique_index("account_credentials", [:type, :username])
  end
end
