defmodule Guildship.Guilds.Membership do
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.{Guilds, Accounts}
  use Guildship.Schema

  schema "guild_memberships" do
    belongs_to :guild, Guilds.Guild
    belongs_to :user, Accounts.User
    field :role, :string, default: "member"

    timestamps()
  end

  def changeset(%Membership{} = membership, params) do
    membership
    |> cast(params, [:guild_id, :user_id, :role])
    |> validate_required([:guild_id, :user_id])
    |> unique_constraint(:guild_membership,
      name: "guild_memberships_user_id_guild_id_index",
      message: "Already joined guild."
    )
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
