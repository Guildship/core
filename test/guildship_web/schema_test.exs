defmodule GuildshipWeb.SchemaTest do
  use GuildshipWeb.AbsintheCase, async: true

  describe "Guilds" do
    test "can't create a guild if not logged in" do
      query = """
        mutation {
          createGuild(input: {displayName: "test!"}) {
            displayName
          }
        }
      """

      assert_raise FunctionClauseError, fn -> run(query) end
    end

    test "can create a guild if logged in" do
      user = insert(:user)

      query = """
        mutation {
          createGuild(input: {displayName: "test!"}) {
            displayName
          }
        }
      """

      actual = run(query, context: %{current_user: user})

      assert {:ok,
              %{
                data: %{
                  "createGuild" => %{
                    "displayName" => "test!"
                  }
                }
              }} = actual
    end

    test "can fetch created guilds if admin" do
      admin_user = insert(:user, type: "admin")
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

      actual = run(query, context: %{current_user: admin_user})

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
