defmodule Guildship.Support.Feedback do
  use Guildship.Schema
  import Ecto.Changeset
  alias Guildship.Accounts.User
  alias __MODULE__

  schema "feedback" do
    field :message, :string
    belongs_to :user, User

    timestamps()
  end

  def changeset(%Feedback{} = feedback, params) do
    feedback
    |> cast(params, [:message, :user_id])
    |> validate_required([:message])
  end

  def new(%Feedback{} = feedback, params) do
    feedback
    |> changeset(params)
  end
end
