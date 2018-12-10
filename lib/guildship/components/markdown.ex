defmodule Guildship.Components.Markdown do
  @moduledoc """
  Module for dealing with markdown components
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  embedded_schema do
    field :markdown, :string
    field :meta, :map
  end

  def new(module = %Markdown{}, params) do
    module
    |> cast(params, [:markdown, :meta])
    |> validate_required([:markdown, :meta])
    |> convert_params()
  end

  defp convert_params(data = %Ecto.Changeset{changes: changes, valid?: true}) do
    %{markdown: value, meta: meta} = changes
    changes = %{type: "markdown", value: value, meta: meta}

    data
    |> delete_change(:markdown)
    |> change(changes)
  end
end
