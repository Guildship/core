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
      user = insert(:user, type: "user")

      assert {:ok, %Accounts.User{type: "admin"}} =
               Accounts.promote_user_to_admin(user)
    end

    test "cannot promote an admin to admin" do
      user = insert(:user, type: "admin")

      assert {:error, _msg} = Accounts.promote_user_to_admin(user)
    end

    test "non-guildship admins can't promote a regular user to guildship admin" do
      user = insert(:user, type: "user")
      regular_user = insert(:user, type: "user")

      assert false ==
               Bodyguard.permit?(Accounts, :promote_user_to_admin, user,
                 user: regular_user
               )
    end

    test "guildship admins can promote a regular user to guildship admin" do
      guildship_admin = insert(:user, type: "admin")
      regular_user = insert(:user, type: "user")

      assert true ==
               Bodyguard.permit?(
                 Accounts,
                 :promote_user_to_admin,
                 guildship_admin,
                 user: regular_user
               )
    end

    test "guildship admins cannot delete a guildship admin" do
      [guildship_admin, another_guildship_admin] =
        insert_pair(:user, type: "admin")

      assert false ==
               Bodyguard.permit?(Accounts, :delete_user, guildship_admin,
                 user: another_guildship_admin
               )
    end

    test "guildship admins cannot demote a guildship admin" do
      [guildship_admin, another_guildship_admin] =
        insert_pair(:user, type: "admin")

      assert false ==
               Bodyguard.permit?(Accounts, :demote_admin, guildship_admin,
                 user: another_guildship_admin
               )
    end
  end
end
