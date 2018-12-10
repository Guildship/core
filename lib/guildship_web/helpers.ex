defmodule GuildshipWeb.Helpers do
  @moduledoc """
  Helpers for things that need a hand
  """

  alias Ecto.Changeset

  def changeset_to_absinthe_error_message(changeset = %Changeset{}) do
    changeset
    |> Changeset.traverse_errors(&traverse_errors/1)
  end

  defp traverse_errors({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
