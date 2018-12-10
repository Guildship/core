defmodule GuildshipWeb.Schema do
  @moduledoc """
  The Graphql schema for the Guildship Graphql API.
  """
  use Absinthe.Schema
  alias __MODULE__
  alias Guildship.{Accounts, Guilds}
  alias GuildshipWeb.Resolvers.{AccountResolver, GuildResolver}
  alias Schema.Middleware

  import_types(Absinthe.Type.Custom)
  import_types(Schema.GuildshipTypes)
  import_types(Schema.AccountTypes)
  import_types(Schema.GuildTypes)

  def middleware(middleware, field, object) do
    middleware
    |> apply(:errors, field, object)
    |> apply(:debug, field, object)
    |> apply(:apollo_tracing, field, object)
  end

  defp apply(middleware, :errors, _field, _object) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  defp apply(middleware, :debug, _field, _object) do
    if System.get_env("DEBUG") do
      [{Middleware.Debug, :start}] ++ middleware
    else
      middleware
    end
  end

  defp apply(middleware, :apollo_tracing, _field, _object) do
    [ApolloTracing.Middleware.Tracing, ApolloTracing.Middleware.Caching] ++
      middleware
  end

  defp apply(middleware, _, _, _) do
    middleware
  end

  def dataloader() do
    Dataloader.new()
    |> Dataloader.add_source(Accounts, Accounts.data())
    |> Dataloader.add_source(Guilds, Guilds.data())
  end

  def context(cxt) do
    Map.put(cxt, :loader, dataloader())
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  query do
    field :all_users, list_of(:user) do
      description "Gets all users"
      middleware Middleware.Authenticate
      resolve &AccountResolver.get_all_users/3
    end

    field :user, :user do
      arg :user_id, non_null(:hashid)
      resolve &AccountResolver.get_user_by_id/3
    end

    field :me, :user do
      middleware Middleware.Authenticate
      resolve &AccountResolver.get_current_user/3
    end

    field :guilds, list_of(:guild) do
      description "Gets Guilds"
      resolve &GuildResolver.get_guilds/3
    end

    field :guild, :guild do
      arg :guild_id, non_null(:hashid)
      resolve &GuildResolver.get_guild_by_id/3
    end

    field :forum_thread, :forum_thread do
      arg :forum_thread_id, non_null(:hashid)
      resolve &GuildResolver.get_forum_thread_by_id/3
    end
  end

  mutation do
    field :create_account_with_email, :account_creation_object do
      description "Creates an account with an email/password login"
      arg :username, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &AccountResolver.create_account_with_email/3
    end

    field :login_with_email, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &AccountResolver.login_with_email/3

      middleware fn res, _ ->
        with %{value: %{user: user}} <- res do
          %{res | context: Map.put(res.context, :current_user, user)}
        end
      end
    end

    field :create_guild, :guild do
      middleware Middleware.Authenticate
      arg :display_name, non_null(:string)
      resolve &GuildResolver.create_guild/3
    end

    field :create_forum_category, :forum_category do
      middleware Middleware.Authenticate
      arg :name, non_null(:string)
      arg :guild_id, non_null(:hashid)
      resolve &GuildResolver.create_forum_category/3
    end

    field :create_forum_thread, :forum_thread do
      middleware Middleware.Authenticate
      arg :title, non_null(:string)
      arg :guild_id, non_null(:hashid)
      arg :forum_category_id, non_null(:hashid)
      resolve &GuildResolver.create_forum_thread/3
    end
  end
end
