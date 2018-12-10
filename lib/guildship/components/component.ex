defmodule Guildship.Components.Component do
  @moduledoc """
  A Guildship Component

  Components are a super generic data structure to describe "pieces" of a larger puzzle.
  They are nothing by themselves, and require some other thing to determine what
  components belong to other things.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  embedded_schema do
    field :type, :string
    field :value, :string
    field :meta, :map
  end

  def new(component = %Component{}, params) do
    component
    |> cast(params, [:type, :value, :meta])
  end
end
