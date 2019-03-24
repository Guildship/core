defmodule Guildship.GuildTest do
  use Guildship.DataCase, async: true
  alias Guildship.{Accounts, Guilds}

  describe "Guild Forum" do
    test "can create forum categories" do
      guild = insert(:guild)

      assert {:ok, %Guilds.ForumCategory{guild: guild, name: "General"}} =
               Guilds.create_forum_category(%{
                 guild_id: guild.id,
                 name: "General"
               })
    end

    test "can create a thread in a category" do
      forum_category = insert(:forum_category)
      user = insert(:user)

      assert {:ok,
              %Guilds.ForumThread{
                forum_category: forum_category,
                title: "Test Title",
                user: user
              }} =
               Guilds.create_forum_thread(%{
                 forum_category_id: forum_category.id,
                 user_id: user.id,
                 title: "Test Title",
                 body: "Yooo!"
               })
    end

    test "can reply to a thread" do
      thread = insert(:forum_thread)
      user = insert(:user)

      assert {:ok,
              %Guilds.ForumThreadReply{
                forum_thread: thread,
                user: user,
                body: "Yo! Wazzup!"
              }} =
               Guilds.create_forum_thread_reply(%{
                 forum_thread_id: thread.id,
                 user_id: user.id,
                 body: "Yo! Wazzup!"
               })
    end
  end

  describe "Guild Calendar" do
    test "can create a single-day calendar event" do
      %{id: guild_id} = insert(:guild)
      %{id: user_id} = insert(:user)

      assert {:ok,
              %Guilds.CalendarEvent{
                user_id: ^user_id,
                guild_id: ^guild_id,
                title: "Launch Guildship",
                description: "GUILDSHIP IS HERE WOO!",
                start_date: ~D[2050-01-01],
                start_time: nil,
                end_date: ~D[2050-01-01],
                end_time: nil
              }} =
               Guilds.create_calendar_event(%{
                 user_id: user_id,
                 guild_id: guild_id,
                 title: "Launch Guildship",
                 description: "GUILDSHIP IS HERE WOO!",
                 start_date: "2050-01-01",
                 end_date: "2050-01-01"
               })
    end

    test "can create a multiple-day calendar event" do
      user = insert(:user)
      guild = insert(:guild)

      assert {:ok,
              %Guilds.CalendarEvent{
                start_date: ~D[2050-01-01],
                end_date: ~D[2050-01-03]
              }} =
               Guilds.create_calendar_event(%{
                 user_id: user.id,
                 guild_id: guild.id,
                 title: "TEST",
                 start_date: "2050-01-01",
                 end_date: "2050-01-03"
               })
    end

    test "cannot create an event that ends in a past date" do
      user = insert(:user)
      guild = insert(:guild)
      today = Date.utc_today()

      assert {:error, _} =
               Guilds.create_calendar_event(%{
                 user_id: user.id,
                 guild_id: guild.id,
                 title: "test",
                 start_date: today,
                 end_date: Date.add(today, -1)
               })
    end

    test "cannot create an event in a past time" do
      user = insert(:user)
      guild = insert(:guild)
      today = Date.utc_today()
      {:ok, start_time} = Time.new(12, 0, 0)
      {:ok, end_time} = Time.new(11, 0, 0)

      assert {:error, _} =
               Guilds.create_calendar_event(%{
                 user_id: user.id,
                 guild_id: guild.id,
                 title: "test",
                 start_date: today,
                 start_time: start_time,
                 end_date: today,
                 end_time: end_time
               })
    end

    test "cannot create an event if given a start time and not given an end time" do
    end

    test "cannot create an event if not given an end date" do
    end
  end

  describe "Guild Blog" do
    test "can create a news post" do
      guild = insert(:guild)
      user = insert(:user)

      assert {:ok,
              %Guilds.GuildBlogPost{
                user: user,
                guild: guild,
                title: "Howdy Everyone!",
                body: "Wazzap!"
              }} =
               Guilds.create_guild_blog_post(%{
                 user_id: user.id,
                 guild_id: guild.id,
                 title: "Howdy Everyone!",
                 body: "Wazzap!"
               })
    end
  end

  describe "Reactions" do
    test "can react to a blog post" do
      %{id: resource_id} = blog_post = insert(:guild_blog_post)
      %{id: user_id} = user = insert(:user)

      assert {:ok,
              %Guilds.Reaction{
                user_id: user_id,
                reactionable_id: resource_id
              }} =
               Guilds.add_reaction(blog_post, %{
                 user_id: user.id
               })
    end

    test "can react to a forum thread reply" do
      %{id: resource_id} = forum_thread_reply = insert(:forum_thread_reply)
      %{id: user_id} = user = insert(:user)

      assert {:ok,
              %Guilds.Reaction{
                user_id: user_id,
                reactionable_id: resource_id
              }} =
               Guilds.add_reaction(forum_thread_reply, %{
                 user_id: user.id
               })
    end

    test "can react to a calendar event" do
      %{id: resource_id} = calendar_event = insert(:calendar_event)
      %{id: user_id} = user = insert(:user)

      assert {:ok,
              %Guilds.Reaction{
                user_id: user_id,
                reactionable_id: resource_id
              }} =
               Guilds.add_reaction(calendar_event, %{
                 user_id: user.id
               })
    end
  end

  describe "Guild Memberships" do
    test "can join a guild" do
      %{id: user_id} = insert(:user)
      %{id: guild_id} = insert(:guild)

      assert {:ok,
              %Guilds.Membership{
                user_id: ^user_id,
                guild_id: ^guild_id
              }} =
               Guilds.join_guild(%{
                 guild_id: guild_id,
                 user_id: user_id
               })
    end

    test "can leave a guild" do
      %{user_id: user_id, guild_id: guild_id} =
        membership = insert(:guild_membership)

      assert {:ok,
              %Guilds.Membership{
                user_id: ^user_id,
                guild_id: ^guild_id
              }} = Guilds.leave_guild(membership)
    end

    test "members have roles" do
      %{id: user_id} = insert(:user)
      %{id: guild_id} = insert(:guild)

      assert {:ok,
              %Guilds.Membership{
                user_id: ^user_id,
                guild_id: ^guild_id,
                role: "member"
              }} =
               Guilds.join_guild(%{
                 guild_id: guild_id,
                 user_id: user_id
               })
    end

    test "can change a member's role" do
      membership = insert(:guild_membership)

      assert {:ok,
              %Guilds.Membership{
                role: "moderator"
              }} = Guilds.change_membership_role(membership, "moderator")
    end

    test "when creating a guild, the user that created the guild is the only member and they have an admin role" do
      %{id: user_id} = insert(:user)

      {:ok, guild} =
        Guilds.create_guild(%{
          user_id: user_id,
          display_name: "TEST"
        })

      guild = guild |> Repo.preload([:guild_memberships])

      assert [%Guilds.Membership{user_id: ^user_id}] = guild.guild_memberships
    end
  end
end
