defmodule Guildship.Factory do
  use ExMachina.Ecto, repo: Guildship.Repo
  alias Guildship.{Accounts, Guilds, Components}

  def credential_factory do
    %Accounts.Credential{
      type: "email",
      username: Faker.Internet.email(),
      password_hash: "abstemiously-monkey-quintessential-essence"
    }
  end

  def user_factory do
    %Accounts.User{
      username: sequence(Faker.Internet.user_name()),
      credentials: [build(:credential)]
    }
  end

  def guild_factory do
    %Guilds.Guild{
      display_name: Faker.App.name()
    }
  end

  def forum_category_factory do
    %Guilds.ForumCategory{
      guild: build(:guild),
      name: Faker.Commerce.department()
    }
  end

  def forum_thread_factory do
    %Guilds.ForumThread{
      user: build(:user),
      forum_category: build(:forum_category),
      title: Faker.Lorem.sentence()
    }
  end

  def forum_thread_reply_factory do
    %Guilds.ForumThreadReply{
      user: build(:user),
      forum_thread: build(:forum_thread)
    }
  end
end
