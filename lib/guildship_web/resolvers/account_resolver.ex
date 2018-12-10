defmodule GuildshipWeb.Resolvers.AccountResolver do
  @moduledoc """
  Resolvers for accounts
  """
  alias Guildship.Accounts
  alias Guildship.Accounts.User
  import Absinthe.Resolution.Helpers
  import GuildshipWeb.Helpers

  def create_account_with_email(_root, args, _info) do
    credential_params =
      args
      |> Map.drop([:username])
      |> convert_email_to_credential()
      |> Map.put(:type, "email")

    args =
      args
      |> Map.drop([:email, :password])
      |> Map.put(:credential, credential_params)

    case Accounts.create_user(args) do
      {:ok, %User{}} ->
        {:ok, %{status: :ok}}

      {:error, _error_name, changeset = %Ecto.Changeset{}, _changes} ->
        {:error, message: changeset_to_absinthe_error_message(changeset)}

      _ ->
        {:error, message: "Could not create the account"}
    end
  end

  def get_all_users(_root, _args, _info) do
    case Accounts.get_users() do
      [] -> {:ok, []}
      user_list when is_list(user_list) -> {:ok, user_list}
      error -> {:error, error}
    end
  end

  def get_user_by_id(_root, args, _info) do
    case Accounts.get_user_by_id(args.user_id) do
      %User{} = user -> {:ok, user}
      _ -> {:error, :not_found}
    end
  end

  def get_current_user(root, _args, %{context: %{current_user: user}} = info) do
    get_user_by_id(root, %{user_id: user.id}, info)
  end

  defp convert_email_to_credential(%{email: email, password: password}) do
    %{username: email, password: password}
  end

  def get_credential(
        %User{id: target_user_id} = root,
        args,
        %{
          context: %{current_user: %User{id: current_user_id}}
        } = info
      ) do
    case current_user_id == target_user_id do
      true ->
        dataloader(Accounts).(root, args, info)

      _ ->
        {:ok, []}
    end
  end

  def get_credential(_root, _args, _info) do
    {:ok, []}
  end

  def login_with_email(_, %{email: email, password: password}, _) do
    case Accounts.login_with_email(email, password) do
      {:ok, user} ->
        token = GuildshipWeb.Authentication.sign(%{id: user.id})
        {:ok, %{token: token, user: user}}

      _ ->
        {:error, "incorrect email or password"}
    end
  end
end
