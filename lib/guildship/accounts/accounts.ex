defmodule Guildship.Accounts do
  @moduledoc """
  Context for Identity-related things.
  """
  @behaviour Bodyguard.Policy

  import Ecto.Query
  alias Ecto.Multi
  alias Guildship.Accounts.{User, Credential}
  alias Guildship.Repo

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  def authorize(:delete_user, _, %{user: %User{type: "admin"}}), do: false

  def authorize(action, %User{type: "admin"}, _)
      when action in [
             :get_all_users,
             :promote_user_to_admin,
             :delete_user,
             :edit_user
           ],
      do: true

  def authorize(_, _, _), do: false

  def create_user(args) do
    %{username: username, credential: credential_params} = args

    case Multi.new()
         |> Multi.insert(:user, User.new(%User{}, %{username: username}))
         |> Multi.merge(fn %{user: user} ->
           add_user_externals(user, credential_params)
         end)
         |> Repo.transaction() do
      {:ok, %{user: user}} -> {:ok, user}
      error -> error
    end
  end

  def get_user_by_id(id) do
    Repo.get(User, id)
  end

  def promote_user_to_admin(%User{type: "user"} = user) do
    user
    |> edit_user(%{type: "admin"})
  end

  def promote_user_to_admin(%User{type: "admin"}) do
    {:error, "User is already an admin."}
  end

  def edit_user(%User{} = user, params) do
    user
    |> User.edit(params)
    |> Repo.update()
  end

  def login_with_email(email, password) do
    query =
      from c in Credential,
        inner_join: u in assoc(c, :user),
        where: c.type == "email" and c.username == ^email,
        preload: [:user],
        select: c

    case Repo.one(query) do
      credential = %Credential{} ->
        case check_password(credential, password) do
          true -> {:ok, credential.user}
          false -> {:error, :not_found}
        end

      _ ->
        {:error, :not_found}
    end
  end

  defp check_password(credential, password) do
    task =
      Task.async(fn ->
        Argon2.verify_pass(password, credential.password_hash)
      end)

    Task.await(task, :infinity)
  end

  def get_users() do
    Repo.all(User)
  end

  defp add_user_externals(user = %User{}, credential_params) do
    credential_params = credential_params |> Map.put(:user_id, user.id)
    credential = Credential.new(%Credential{}, credential_params)

    Multi.new()
    |> Multi.insert(:credential, credential)
  end
end
