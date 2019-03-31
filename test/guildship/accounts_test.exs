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

    test "you can't create a user with an invalid email" do
      assert {:error, _, _, _} =
               Accounts.create_user(%{
                 username: "test",
                 credential: %{
                   type: "email",
                   username: "not-a-real-email",
                   password: "password"
                 }
               })
    end

    test "you can't create a user with password less than 8 characters" do
      assert {:error, _, _, _} =
               Accounts.create_user(%{
                 username: "test",
                 credential: %{
                   type: "email",
                   username: "test@test",
                   password: "1234567"
                 }
               })
    end

    test "can get all users" do
      [%{id: user1_id}, %{id: user2_id}, %{id: user3_id}] =
        insert_list(3, :user)

      assert [
               %Accounts.User{id: ^user1_id},
               %Accounts.User{id: ^user2_id},
               %Accounts.User{id: ^user3_id}
             ] = Accounts.get_users()
    end

    test "can get a user by id" do
      %{id: user_id} = insert(:user)

      assert %Accounts.User{id: ^user_id} = Accounts.get_user_by_id(user_id)
    end

    test "can login with email and password" do
      {:ok, %{id: user_id}} =
        Accounts.create_user(%{
          username: "test",
          credential: %{
            type: "email",
            username: "bob@bob.bob",
            password: "password"
          }
        })

      assert {:ok, %Accounts.User{id: ^user_id}} =
               Accounts.login_with_email("bob@bob.bob", "password")
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

    test "guildship users cannot get all users" do
      regular_user = insert(:user, type: "user")

      assert false == Bodyguard.permit?(Accounts, :get_all_users, regular_user)
    end

    test "guildship admins can get all users" do
      guildship_admin = insert(:user, type: "admin")

      assert true ==
               Bodyguard.permit?(Accounts, :get_all_users, guildship_admin)
    end
  end
end
