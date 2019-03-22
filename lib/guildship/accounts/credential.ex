defmodule Guildship.Accounts.Credential do
  @moduledoc false
  use Guildship.Schema
  import Ecto.Changeset
  alias Guildship.Accounts.User
  alias __MODULE__

  schema "account_credentials" do
    field :type, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    belongs_to :user, User
  end

  defp changeset(%Credential{} = credential, params) do
    credential
    |> cast(params, [:user_id, :type, :username, :password])
    |> validate_required([:type, :username, :user_id])
    |> validate_email()
    |> validate_password()
  end

  def new(%Credential{} = credential, params) do
    credential
    |> changeset(params)
    |> put_pass_hash()
  end

  defp put_pass_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} =
           changeset
       ) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

  defp validate_email(
         %Ecto.Changeset{valid?: true, changes: %{type: "email"}} = changeset
       ) do
    changeset
    # Shamelessly derived from http://regexlib.com/REDetails.aspx?regexp_id=28
    |> validate_format(:username, ~r/[\w-]+@([\w-]+\.?)+[\w-]+/)
  end

  defp validate_email(changeset), do: changeset

  defp validate_password(
         %Ecto.Changeset{valid?: true, changes: %{type: "email"}} = changeset
       ) do
    changeset
    |> validate_length(:password, min: 8)
  end

  defp validate_password(changeset), do: changeset
end
