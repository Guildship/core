defmodule Guildship.Accounts.User do
  @moduledoc false
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.Accounts.Credential
  alias Guildship.{Support, Guilds}

  schema "users" do
    field :username, :string
    field :type, :string, default: "user"
    has_many :credentials, Credential, on_delete: :delete_all
    has_many :flags, {"users_flags", Support.Flag}, foreign_key: :flaggable_id
    has_many :guild_memberships, Guilds.Membership, on_delete: :delete_all

    timestamps()
  end

  defp changeset(%User{} = user, params) do
    user
    |> cast(params, [:username, :type])
    |> validate_required([:username, :type])
    |> unique_constraint(:username)
    |> validate_username()
  end

  def new(%User{} = user, params) do
    user
    |> changeset(params)
  end

  def edit(%User{} = user, params) do
    user
    |> changeset(params)
  end

  defp validate_username(%Ecto.Changeset{valid?: true} = changeset) do
    changeset
    |> validate_length(:username, max: 15, min: 3)
    |> validate_format(:username, ~r/^[\w\d]+$/)
  end

  defp validate_username(changeset), do: changeset
end
