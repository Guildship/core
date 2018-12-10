defmodule GuildshipWeb.Authentication do
  @user_salt "a dash of salt"

  def sign(data) do
    Phoenix.Token.sign(GuildshipWeb.Endpoint, @user_salt, data)
  end

  def verify(token) do
    Phoenix.Token.verify(GuildshipWeb.Endpoint, @user_salt, token,
      max_age: 7 * 3600
    )
  end
end
