defmodule Guildship.Guilds.Reaction do
  use Guildship.Schema
  alias Guildship.Accounts

  schema "abstract table: reactions" do
    field :reactionable_id, :integer
    belongs_to :user, Accounts.User
  end
end
