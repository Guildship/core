defmodule Guildship.GuardianTest do
  use Guildship.DataCase
  alias Guildship.Accounts.User

  test "can create a JWT" do
    user = insert(:user)

    actual = Guildship.Guardian.encode_and_sign(user)

    assert {:ok, _jwt, _decoded_jwt} = actual
  end

  test "can derive user from token" do
    %User{id: user_id} = user = insert(:user)
    {:ok, jwt, _decoded_jwt} = Guildship.Guardian.encode_and_sign(user)
    actual = Guildship.Guardian.resource_from_token(jwt)

    assert {:ok, %User{id: ^user_id}, _} = actual
  end
end
