defmodule GuildshipWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers
  import GuildshipWeb.AbsintheHelpers
  alias Guildship.{Guilds, Accounts}
  alias GuildshipWeb.Resolvers

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Accounts, Accounts.data())
      |> Dataloader.add_source(Guilds, Guilds.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  import_types Absinthe.Type.Custom
  connection(node_type: :guild)

  node object(:guild) do
    meta :cache, max_age: 30
    field :display_name, non_null(:string)
    field :created_at, non_null(:datetime)
    field :updated_at, non_null(:datetime)
  end

  node object(:guild_membership) do
    field :role, non_null(:string)
    field :guild, non_null(:guild), resolve: dataloader(Guilds)
    field :user, non_null(:user), resolve: dataloader(Accounts)
  end

  node object(:user) do
    meta :cache, max_age: 30
    field :username, :string
    field :created_at, :datetime
    field :updated_at, :datetime

    field :guild_memberships, list_of(:guild_membership),
      resolve: fn %Accounts.User{} = user,
                  args,
                  %{context: %{current_user: current_user}} = ctx ->
        with :ok <-
               Bodyguard.permit(Guilds, :get_memberships, current_user,
                 user: user
               ) do
          apply(dataloader(Guilds), [user, args, ctx])
        end
      end
  end

  node interface do
    resolve_type fn
      %Guilds.Guild{}, _ -> :guild
      %Accounts.User{}, _ -> :user
      %Guilds.Membership{}, _ -> :guild_membership
      _, _ -> nil
    end
  end

  query do
    node field do
      resolve_safe fn
        %{type: :guild, id: local_id}, _ ->
          {:ok, Guilds.get_guild_by_id(local_id)}

        %{type: :user, id: local_id}, _ ->
          {:ok, Accounts.get_user_by_id(local_id)}

        %{type: :guild_membership, id: local_id},
        %{context: %{current_user: current_user}} ->
          with membership <-
                 Guilds.get_membership_by_id(local_id),
               :ok <-
                 Bodyguard.permit(Guilds, :get_membership, current_user,
                   membership: membership
                 ) do
            {:ok, membership}
          end

        _, _ ->
          {:error, "Unknown node"}
      end
    end

    @desc """
    ### CAUTION!

    This field only works for logged-in admins.
    To see all public guilds use the `publicGuilds` query.
    """
    connection field :guilds, node_type: :guild do
      resolve_safe &Resolvers.Guilds.guilds/3
    end

    connection field :public_guilds, node_type: :guild do
      resolve_safe &Resolvers.Guilds.public_guilds/3
    end

    field :me, :user do
      resolve_safe &Resolvers.Accounts.me/3
    end
  end

  mutation do
    payload field :create_user_with_email_and_password do
      input do
        field :username, non_null(:string)
        field :email, non_null(:string)
        field :password, non_null(:string)
      end

      output do
        field :user, non_null(:user)
      end

      resolve_safe &Resolvers.Accounts.create_user_with_email_and_password/3
    end

    payload field :login_with_email_and_password do
      input do
        field :email, non_null(:string)
        field :password, non_null(:string)
      end

      output do
        field :user, non_null(:user)
        field :token, non_null(:string)
      end

      resolve_safe &Resolvers.Accounts.login_with_email_and_password/3
    end

    payload field :join_guild do
      input do
        field :guild_id, non_null(:id)
      end

      output do
        field :guild_membership, :guild_membership
      end

      resolve_safe &Resolvers.Guilds.join_guild/3
    end

    payload field :create_guild do
      input do
        field :display_name, non_null(:string)
      end

      output do
        field :guild, non_null(:guild)
      end

      resolve_safe &Resolvers.Guilds.create_guild/3
    end
  end
end
