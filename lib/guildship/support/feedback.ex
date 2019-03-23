defmodule Guildship.Support.Feedback do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "feedback" do
    field :message, :string
  end

  def changeset(%Feedback{} = feedback, params) do
    feedback
    |> cast(params, [:message])
    |> validate_required([:message])
  end

  def new(%Feedback{} = feedback, params) do
    feedback
    |> changeset(params)
  end
end
