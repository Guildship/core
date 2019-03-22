defmodule Guildship.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @timestamps_opts type: :utc_datetime, inserted_at: :created_at
    end
  end
end
