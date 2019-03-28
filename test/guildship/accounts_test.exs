defmodule Guildship.AccountsTest do
  use Guildship.DataCase, async: true
  alias Guildship.Accounts

  describe "Users" do
    test "new users are considered regular users" do
      assert {:ok, %Accounts.User{type: "user", username: "test"}} =
               Accounts.create_user(%{
                 username: "test",
                 credential: %{
                   type: "email",
                   username: "test@test.test",
                   password: "password"
                 }
               })
    end

    test "can promote a user to guildship admin" do
    end

    test "non-guildship admins can't promote a regular user to guildship admin" do
    end

    test "guildship admins can promote a regular user to guildship admin" do
    end

    test "guildship admins cannot delete a guildship admin" do
    end

    test "guildship admins cannot demote a guildship admin" do
    end
  end
end
