defmodule GuildshipWeb.AccountSchemaTest do
  @moduledoc false
  use GuildshipWeb.AbsintheCase

  describe "mutations" do
    test "can create an account with just an email and password" do
      query = """
      mutation CreateAccountWithEmail($username: String!, $email: String!, $password: String!) {
        createAccountWithEmail(username: $username, email: $email, password: $password) {
          status
        }
      }
      """

      actual =
        run(query,
          variables: %{
            "username" => "bobthebuilder",
            "email" => "test@test.test",
            "password" => "yoloswaggins"
          }
        )

      assert {:ok,
              %{
                data: %{
                  "createAccountWithEmail" => %{
                    "status" => "OK"
                  }
                }
              }} = actual
    end

    test "fails when giving an invalid username" do
      query = """
      mutation CreateAccountWithEmail($username: String!, $email: String!, $password: String!) {
        createAccountWithEmail(username: $username, email: $email, password: $password) {
          status
        }
      }
      """

      actual =
        run(query,
          variables: %{
            "username" => "I'm an invalid username",
            "email" => "test@test.test",
            "password" => "password"
          }
        )

      refute {:ok, %{data: %{"createAccountWithEmail" => %{"status" => "OK"}}}} ==
               actual
    end

    test "fails when giving an invalid email" do
      query = """
      mutation CreateAccountWithEmail(
        $username: String!,
        $email: String!,
        $password: String!) {
        createAccountWithEmail(username: $username, email: $email, password: $password) {
          status
        }
      }
      """

      no_at_symbol =
        run(query,
          variables: %{
            "username" => "sean",
            "email" => "testtest.test",
            "password" => "password"
          }
        )

      no_tld =
        run(query,
          variables: %{
            "username" => "sean",
            "email" => "test@",
            "password" => "password"
          }
        )

      no_user =
        run(query,
          variables: %{
            "username" => "sean",
            "email" => "@test",
            "password" => "password"
          }
        )

      refute {:ok, %{data: %{"createAccountWithEmail" => %{"status" => "OK"}}}} ==
               no_at_symbol

      refute {:ok, %{data: %{"createAccountWithEmail" => %{"status" => "OK"}}}} ==
               no_tld

      refute {:ok, %{data: %{"createAccountWithEmail" => %{"status" => "OK"}}}} ==
               no_user
    end

    test "fails when giving an invalid password" do
      query = """
      mutation CreateAccountWithEmail(
        $username: String!,
        $email: String!,
        $password: String!) {
        createAccountWithEmail(username: $username, email: $email, password: $password) {
          status
        }
      }
      """

      short =
        run(query,
          variables: %{
            "username" => "sean",
            "email" => "test@test",
            "password" => "short"
          }
        )

      refute {:ok, %{data: %{"createAccountWithEmail" => %{"status" => "OK"}}}} ==
               short
    end
  end
end
