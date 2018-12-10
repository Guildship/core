defmodule Guildship.Components do
  @moduledoc """
  Components y'all
  """
  alias __MODULE__
  alias Components.{Component, Markdown}

  defp meta_to_map(meta) do
    meta |> Enum.into(%{})
  end

  def create_markdown_component(markdown, meta \\ []) do
    %Markdown{}
    |> Markdown.new(%{value: markdown, meta: meta_to_map(meta)})
    |> create_component()
  end

  defp create_component(%Ecto.Changeset{changes: params}) do
    %Component{}
    |> Component.new(params)
  end
end
