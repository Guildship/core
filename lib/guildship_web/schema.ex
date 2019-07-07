defmodule GuildshipWeb.Schema do
  use Absinthe.Schema
  use ApolloTracing
  use Absinthe.Relay.Schema, :modern
  use Absinthe.Relay.Schema.Notation, :modern
  alias Guildship.{Guilds, Accounts}
  alias GuildshipWeb.Resolvers

  import_types Absinthe.Type.Custom
  connection(node_type: :guild)

  node object(:guild) do
    meta :cache, max_age: 30
    field :display_name, :string
    field :created_at, :datetime
    field :updated_at, :datetime
  end

  node object(:user) do
    meta :cache, max_age: 30
    field :username, :string
    field :created_at, :datetime
    field :updated_at, :datetime
  end

  node interface do
    resolve_type fn
      %Guilds.Guild{}, _ -> :guild
      %Accounts.User{}, _ -> :user
      _, _ -> nil
    end
  end

  query do
    node field do
      resolve fn
        %{type: :guild, id: local_id}, _ ->
          {:ok, Guilds.get_guild_by_id(local_id)}

        %{type: :user, id: local_id}, _ ->
          {:ok, Accounts.get_user_by_id(local_id)}

        _, _ ->
          {:error, "Unknown node"}
      end
    end

    @desc "list guilds"
    connection field :guilds, node_type: :guild do
      resolve &Resolvers.Guilds.guilds/3
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

      resolve &Resolvers.Accounts.create_user_with_email_and_password/3
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

      resolve &Resolvers.Accounts.login_with_email_and_password/3
    end

    payload field :create_guild do
      input do
        field :display_name, non_null(:string)
      end

      output do
        field :guild, non_null(:guild)
      end

      resolve &Resolvers.Guilds.create_guild/3
    end
  end
end
