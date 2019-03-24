defmodule Guildship.Guilds.Membership do
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.{Guilds, Accounts}
  use Guildship.Schema

  schema "guild_memberships" do
    belongs_to :guild, Guilds.Guild
    belongs_to :user, Accounts.User
    field :role, :string

    timestamps()
  end

  def changeset(%Membership{} = membership, params) do
    membership
    |> cast(params, [:guild_id, :user_id, :role])
    |> validate_required([:guild_id, :user_id])
  end

  def new(%Membership{} = membership, params) do
    membership
    |> changeset(params)
  end

  def edit(%Membership{} = membership, params) do
    membership
    |> changeset(params)
  end
end
