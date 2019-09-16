defmodule GuildshipWeb.Absinthe.IDTranslatorTest do
  use GuildshipWeb.AbsintheCase, async: true
  alias GuildshipWeb.Schema
  alias GuildshipWeb.Absinthe.IDTranslator

  test "it can encode IDs" do
    actual = IDTranslator.to_global_id("User", 1, Schema)
    assert {:ok, _} = actual
  end

  test "it can decode IDs" do
    {:ok, global_id} = IDTranslator.to_global_id("User", 1, Schema)
    actual = IDTranslator.from_global_id(global_id, Schema)
    assert {:ok, "User", 1} = actual
  end
end
