defmodule GuildshipWeb.Resolvers.Accounts do
  alias Guildship.Accounts

  def login_with_email_and_password(_, args, %{context: context}) do
    case context do
      %{current_user: _} -> {:error, "Can't log in if already logged in!"}
      _ -> Accounts.login_with_email(args.email, args.password)
    end
  end
end
