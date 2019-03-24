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

    has_many :reactions, {"calendar_events_reactions", Guilds.Reaction},
      foreign_key: :reactionable_id
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
    |> validate_required([:user_id, :guild_id, :title, :start_date, :end_date])
    |> validate_dates_and_times()
  end

  def new(%CalendarEvent{} = calendar_event, params) do
    calendar_event
    |> changeset(params)
  end

  defp validate_dates_and_times(
         %Ecto.Changeset{
           valid?: true,
           changes: %{
             start_date: start_date,
             start_time: start_time,
             end_time: end_time,
             end_date: end_date
           }
         } = changeset
       )
       when start_time != nil and end_time != nil do
    case {Date.compare(end_date, start_date),
          Time.compare(end_time, start_time)} do
      {:eq, :lt} ->
        add_error(changeset, :end_time, "End time can't be before start time")

      {:lt, _} ->
        add_error(changeset, :end_date, "End date can't be before start date")

      _ ->
        changeset
    end
  end

  defp validate_dates_and_times(
         %Ecto.Changeset{
           valid?: true,
           changes: %{
             start_time: %Time{}
           }
         } = changeset
       ) do
    changeset
    |> validate_required([:end_time])
  end

  defp validate_dates_and_times(
         %Ecto.Changeset{
           valid?: true,
           changes: %{start_date: start_date, end_date: end_date}
         } = changeset
       ) do
    case Date.compare(end_date, start_date) do
      :lt ->
        add_error(changeset, :end_date, "End date can't be before start date")

      _ ->
        changeset
    end
  end

  defp validate_dates_and_times(changeset), do: changeset
end
