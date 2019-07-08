defmodule GuildshipWeb.AbsintheCase do
  @moduledoc """
  Test helpers for running Absinthe stuff
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case
      use Guildship.DataCase, async: true
      import GuildshipWeb.AbsintheCase
    end
  end

  def run(document, options \\ [], schema \\ GuildshipWeb.Schema) do
    Absinthe.run(document, schema, options)
  end

  def to_global_id(node_type, source_id, schema \\ GuildshipWeb.Schema) do
    Absinthe.Relay.Node.to_global_id(
      node_type,
      source_id,
      schema
    )
  end
end
