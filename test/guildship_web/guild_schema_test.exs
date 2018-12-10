defmodule GuildshipWeb.GuildSchemaTest do
  use GuildshipWeb.AbsintheCase

  test "can create a guild" do
    user = insert(:user)

    query = """
      mutation($displayName: String!) {
        createGuild(displayName: $displayName) {
          displayName
        }
      }
    """

    actual =
      run(query,
        variables: %{"displayName" => "Cool Guild"},
        context: %{current_user: user}
      )

    assert {:ok,
            %{
              data: %{
                "createGuild" => %{
                  "displayName" => "Cool Guild"
                }
              }
            }} = actual
  end
end
