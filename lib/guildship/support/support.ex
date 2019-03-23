defmodule Guildship.Support do
  import Ecto
  alias Guildship.Repo
  alias Guildship.Support.{Feedback}

  def send_feedback(params) do
    %Feedback{}
    |> Feedback.new(params)
    |> Repo.insert()
  end

  def flag_content(content) do
    Repo.insert(build_assoc(content, :flags))
  end
end
