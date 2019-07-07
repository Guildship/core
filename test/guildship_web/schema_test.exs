defmodule GuildshipWeb.SchemaTest do
  use GuildshipWeb.AbsintheCase, async: true

  describe "Accounts" do
    test "cannot log in with email/password if logged in" do
      user = insert(:user)

      insert(:credential,
        user: user,
        username: "test@test.test",
        password: "test"
      )

      query = """
        mutation {
          loginWithEmailAndPassword(input: {email: "bob@bob.bob", password: "test"}) {
            token
          }
        }
      """

      actual = run(query, context: %{current_user: user})

      assert {:ok,
              %{
                errors: [_]
              }} = actual
    end

    test "can log in with email/password if not logged in" do
      user = insert(:user)

      insert(:credential,
        user: user,
        username: "test@test.test",
        password_hash: Argon2.hash_pwd_salt("test")
      )

      query = """
        mutation {
          loginWithEmailAndPassword(input: {email: "test@test.test", password: "test"}) {
            token
          }
        }
      """

      actual = run(query)

      assert {:ok,
              %{
                data: %{
                  "loginWithEmailAndPassword" => %{
                    "token" => _some_token
                  }
                }
              }} = actual
    end
  end

  describe "Guilds" do
    test "can't create a guild if not logged in" do
      query = """
        mutation {
          createGuild(input: {displayName: "test!"}) {
            displayName
          }
        }
      """

      actual = run(query)

      assert {:ok, %{errors: [_]}} = actual
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
