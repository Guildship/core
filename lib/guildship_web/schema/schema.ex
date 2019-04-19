defmodule GuildshipWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  use Absinthe.Relay.Schema.Notation, :modern
  alias Guildship.{Repo, Guilds}
  alias GuildshipWeb.Resolvers

  import_types Absinthe.Type.Custom
  connection(node_type: :guild)

  node object(:guild) do
    field :display_name, :string
    field :created_at, :datetime
    field :updated_at, :datetime
  end

  node interface do
    resolve_type fn
      %Guilds.Guild{}, _ -> :guild
      _, _ -> nil
    end
  end

  query do
    node field do
      resolve fn
        %{type: :guild, id: local_id}, _ ->
          {:ok, Repo.get(Guilds.Guild, local_id)}

        _, _ ->
          {:error, "Unknown node"}
      end
    end

    @desc "list guilds"
    connection field :guilds, node_type: :guild do
      resolve &Resolvers.Guilds.guilds/3
    end
  end
end
