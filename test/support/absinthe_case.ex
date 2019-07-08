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
      import GuildshipWeb.AbsintheHelpers
    end
  end

  def run(document, options \\ [], schema \\ GuildshipWeb.Schema) do
    Absinthe.run(document, schema, options)
  end
end
