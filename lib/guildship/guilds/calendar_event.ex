defmodule Guildship.Guilds.CalendarEvent do
  use Guildship.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Guildship.{Accounts, Guilds}

  schema "calendar_events" do
    field :title, :string
    field :description, :string
    field :start_date, :date
    field :start_time, :time
    field :end_date, :date
    field :end_time, :time
    belongs_to :user, Accounts.User
    belongs_to :guild, Guilds.Guild
  end

  def changeset(%CalendarEvent{} = calendar_event, params) do
    calendar_event
    |> cast(params, [
      :user_id,
      :guild_id,
      :title,
      :description,
      :start_date,
      :start_time,
      :end_date,
      :end_time
    ])
  end

  def new(%CalendarEvent{} = calendar_event, params) do
    calendar_event
    |> changeset(params)
  end
end
