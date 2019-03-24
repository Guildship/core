defmodule Guildship.Factory do
  use ExMachina.Ecto, repo: Guildship.Repo
  alias Guildship.{Accounts, Guilds}

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

  def guild_blog_post_factory do
    %Guilds.GuildBlogPost{
      user: build(:user),
      guild: build(:guild),
      title: Faker.Lorem.sentence(),
      body: Faker.Lorem.paragraphs() |> Enum.join("\n\n")
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
      forum_thread: build(:forum_thread),
      body: Faker.Lorem.sentences() |> Enum.join()
    }
  end

  def calendar_event_factory do
    %Guilds.CalendarEvent{
      guild: build(:guild),
      user: build(:user),
      title: Faker.Lorem.sentence(),
      start_date: Date.utc_today(),
      end_date: Date.utc_today()
    }
  end
end
