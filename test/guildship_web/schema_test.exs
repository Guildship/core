defmodule GuildshipWeb.SchemaTest do
  use GuildshipWeb.AbsintheCase, async: true

  describe "Guilds" do
    test "can fetch created guilds" do
      insert(:guild)
      query = "
        query {
          guilds(first: 10) {
            edges {
              node {
                id
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
                          "id" => _some_id
                        }
                      }
                    ]
                  }
                }
              }} = actual
    end
  end
end
