defmodule GuildshipWeb.SchemaTest do
  use GuildshipWeb.AbsintheCase, async: true

  describe "Guilds" do
    test "can fetch created guilds" do
      insert(:guild, display_name: "test!")
      query = "
        query {
          guilds(first: 10) {
            edges {
              node {
                displayName
              }
            }
          }
        }
      "

      actual = run(query)

      assert {:ok,
              %{
                data: %{
                  "guilds" => %{
                    "edges" => [
                      %{
                        "node" => %{
                          "displayName" => "test!"
                        }
                      }
                    ]
                  }
                }
              }} = actual
    end
  end
end
