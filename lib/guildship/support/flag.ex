defmodule Guildship.Support.Flag do
  use Guildship.Schema

  schema "abstract table: flags" do
    field :flaggable_id, :integer

    timestamps()
  end
end
