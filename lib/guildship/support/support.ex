defmodule Guildship.Support do
  alias Guildship.Repo
  alias Guildship.Support.{Feedback}

  def send_feedback(params) do
    %Feedback{}
    |> Feedback.new(params)
    |> Repo.insert()
  end
end
