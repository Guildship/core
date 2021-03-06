defmodule GuildshipWeb.SchemaTest do
  use GuildshipWeb.AbsintheCase, async: true

  describe "Accounts" do
    test "can create a user with email/password" do
      query = """
        mutation {
          createUserWithEmailAndPassword(input: {username: "sean", email: "test@test.test", password: "testpassword"}) {
            user {
              id
              username
            }
          }
        }
      """

      assert {:ok,
              %{
                data: %{
                  "createUserWithEmailAndPassword" => %{
                    "user" => %{
                      "id" => _some_id,
                      "username" => "sean"
                    }
                  }
                }
              }} = run(query)
    end

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

      {:ok,
       %{
         data: %{
           "loginWithEmailAndPassword" => %{
             "token" => token
           }
         }
       }} = actual

      assert {:ok, _} = Guildship.Guardian.decode_and_verify(token)
    end

    test "I can't do a me query if not logged in" do
      query = """
        query {
          me {
            username
            createdAt
            updatedAt
          }
        }
      """

      actual = run(query)

      assert {:ok, %{errors: [_]}} = actual
    end

    test "I can get my account if logged in" do
      user = insert(:user, username: "test")

      query = """
        query {
          me {
            username
            createdAt
            updatedAt
          }
        }
      """

      actual = run(query, context: %{current_user: user})

      assert {:ok,
              %{
                data: %{
                  "me" => %{
                    "username" => "test",
                    "createdAt" => _created_at,
                    "updatedAt" => _updated_at
                  }
                }
              }} = actual
    end

    test "I can't get someone else's guild membership" do
      user = insert(:user)
      other_user = insert(:user)
      insert(:guild_membership, user: other_user)
      other_user_id = to_global_id(:user, other_user.id)

      query = """
        query GetUser($id: ID!) {
          node(id: $id) {
            ...on User {
              guildMemberships {
                user {
                  id
                }
              }
            }
          }
        }
      """

      actual =
        run(query,
          context: %{current_user: user},
          variables: %{"id" => other_user_id}
        )

      assert {:ok,
              %{
                data: %{
                  "node" => %{
                    "guildMemberships" => nil
                  }
                },
                errors: [_]
              }} = actual
    end

    test "I can get my own guild memberships" do
      user = insert(:user)
      insert(:guild_membership, user: user)

      query = """
        query {
          me {
            guildMemberships {
              user {
                id
              }
            }
          }
        }
      """

      user_id = to_global_id(:user, user.id, GuildshipWeb.Schema)

      actual = run(query, context: %{current_user: user})

      assert {:ok,
              %{
                data: %{
                  "me" => %{
                    "guildMemberships" => [
                      %{
                        "user" => %{
                          "id" => ^user_id
                        }
                      }
                    ]
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
            guild {
              displayName
            }
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
            guild {
              displayName
            }
          }
        }
      """

      actual = run(query, context: %{current_user: user})

      assert {:ok,
              %{
                data: %{
                  "createGuild" => %{
                    "guild" => %{
                      "displayName" => "test!"
                    }
                  }
                }
              }} = actual
    end

    test "I can't join a guild if already joined" do
      user = insert(:user)
      guild = insert(:guild)
      insert(:guild_membership, user: user, guild: guild)

      guild_id = to_global_id(:guild, guild.id)

      query = """
        mutation JoinGuild($guildId: ID!) {
          joinGuild(input: {guildId: $guildId}) {
            guildMembership {
              guild {
                id
              }
              user {
                id
              }
            }
          }
        }
      """

      actual =
        run(query,
          context: %{current_user: user},
          variables: %{"guildId" => guild_id}
        )

      assert {:ok,
              %{
                data: %{
                  "joinGuild" => nil
                },
                errors: [_]
              }} = actual
    end

    test "I can join a guild" do
      user = insert(:user)
      guild = insert(:guild)
      user_id = to_global_id(:user, user.id)
      guild_id = to_global_id(:guild, guild.id)

      query = """
        mutation JoinGuild($guildId: ID!) {
          joinGuild(input: {guildId: $guildId}) {
            guildMembership {
              guild {
                id
              }
              user {
                id
              }
            }
          }
        }
      """

      actual =
        run(query,
          context: %{current_user: user},
          variables: %{"guildId" => guild_id}
        )

      assert {:ok,
              %{
                data: %{
                  "joinGuild" => %{
                    "guildMembership" => %{
                      "guild" => %{
                        "id" => ^guild_id
                      },
                      "user" => %{
                        "id" => ^user_id
                      }
                    }
                  }
                }
              }} = actual
    end

    test "can't fetch guilds if not admin" do
      insert(:guild)

      query = """
        query {
          guilds(first: 10) {
            edges {
              node {
                id
              }
            }
          }
        }
      """

      actual = run(query)

      assert {:ok, %{errors: [_]}} = actual
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

    test "can fetch public guilds" do
      insert(:guild, display_name: "test!")
      query = "
        query {
          publicGuilds(first: 10) {
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
                  "publicGuilds" => %{
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

    test "can get version info if on dev" do
      query = "
        query {
          versionInfo {
            commitSha
            buildTime
            branchName
          }
        }
      "

      actual = run(query)

      assert {:ok,
              %{
                data: %{
                  "versionInfo" => %{
                    "commitSha" => "__DEVELOPMENT__",
                    "buildTime" => buildTime,
                    "branchName" => branchName
                  }
                }
              }} = actual

      assert {:ok, %DateTime{}, _} = DateTime.from_iso8601(buildTime)
      assert is_binary(branchName) == true
    end

    test "can get version info if deployed" do
      System.put_env([
        {"RENDER_GIT_COMMIT", "68152a59fca86777fc427c4c0f6f0b3784368007"},
        {"RENDER_GIT_BRANCH", "master"}
      ])

      query = "
        query {
          versionInfo {
            commitSha
            buildTime
            branchName
          }
        }
      "

      actual = run(query)

      # Cleanup environment vars
      System.delete_env("RENDER_GIT_COMMIT")
      System.delete_env("RENDER_GIT_BRANCH")

      assert {:ok,
              %{
                data: %{
                  "versionInfo" => %{
                    "commitSha" => "68152a59fca86777fc427c4c0f6f0b3784368007",
                    "buildTime" => _buildTime,
                    "branchName" => "master"
                  }
                }
              }} = actual
    end
  end
end
