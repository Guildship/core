defmodule GuildshipWeb.Resolvers.Accounts do
  alias Guildship.Accounts

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
