defmodule Guildship.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.Accounts.Credential

  schema "users" do
    field :username, :string
    has_many :credentials, Credential, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  defp changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
    |> validate_username()
  end

  def new(%User{} = user, attrs \\ %{}) do
    user
    |> changeset(attrs)
  end

  defp validate_username(%Ecto.Changeset{valid?: true} = changeset) do
    changeset
    |> validate_length(:username, max: 15, min: 3)
    |> validate_format(:username, ~r/^[\w\d]+$/)
  end

  defp validate_username(changeset), do: changeset
end
