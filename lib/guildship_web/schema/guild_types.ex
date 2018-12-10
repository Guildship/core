defmodule GuildshipWeb.Schema.GuildTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers
  alias Guildship.Guilds

  object :guild do
    field :id, non_null(:hashid)
    field :display_name, non_null(:string)
    field :inserted_at, non_null(:datetime)
    field :updated_at, non_null(:datetime)
    field :components, list_of(:component)

    field :forum_categories, list_of(:forum_category) do
      resolve dataloader(Guilds)
    end
  end

  object :forum_category do
    field :id, non_null(:hashid)
    field :name, non_null(:string)
    field :guild, non_null(:guild), resolve: dataloader(Guilds)
    field :forum_threads, list_of(:forum_thread), resolve: dataloader(Guilds)
  end

  object :forum_thread do
    field :id, non_null(:hashid)
    field :author, non_null(:user), resolve: dataloader(Guilds, :user, [])
    field :title, non_null(:string)
    field :guild, non_null(:guild), resolve: dataloader(Guilds)

    field :forum_category, non_null(:forum_category),
      resolve: dataloader(Guilds)

    field :forum_thread_replies, list_of(:forum_thread_reply),
      resolve: dataloader(Guilds)
  end

  object :forum_thread_reply do
    field :id, non_null(:hashid)
    field :author, non_null(:user), resolve: dataloader(Guilds, :user, [])
    field :forum_thread, non_null(:forum_thread), resolve: dataloader(Guilds)
    field :components, list_of(:component)
  end
end
