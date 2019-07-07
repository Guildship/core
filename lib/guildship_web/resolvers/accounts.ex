defmodule GuildshipWeb.Resolvers.Accounts do
  alias Guildship.Accounts

  def me(_, _args, %{context: %{current_user: %Accounts.User{} = user}}) do
    {:ok, user}
  end

  def me(_, _, _) do
    {:error, "Not logged in!"}
  end

  def create_user_with_email_and_password(_, args, _) do
    case Accounts.create_user(%{
           username: args.username,
           credential: %{
             type: "email",
             username: args.email,
             password: args.password
           }
         }) do
      {:ok, user} ->
        {:ok,
         %{
           user: user
         }}

      _ ->
        {:error, "Could not create user."}
    end
  end

  def login_with_email_and_password(_, _, %{context: %{current_user: _}}) do
    {:error, "Can't log in if already logged in!"}
  end

  def login_with_email_and_password(_, %{email: email, password: password}, _) do
    with {:ok, %Accounts.User{} = user} <-
           Accounts.login_with_email(email, password) do
      {:ok, token, _} = Guildship.Guardian.encode_and_sign(user)

      {:ok,
       %{
         user: user,
         token: token
       }}
    end
  end
end
