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

    test "cannot create a forum category if just a guild member" do
    end

    test "can create a forum category if a guild moderator" do
    end

    test "can create a forum category if a guild admin" do
    end

    test "can edit a category" do
      forum_category = insert(:forum_category, name: "Not Edited")

      assert {:ok, %Guilds.ForumCategory{name: "Edited"}} =
               Guilds.edit_forum_category(forum_category, %{name: "Edited"})
    end

    test "regular members cannot edit a category" do
    end

    test "guild moderators can edit a category" do
    end

    test "guild admins can edit a category" do
    end

    test "can delete a category" do
      forum_category = insert(:forum_category)

      assert {:ok, %Guilds.ForumCategory{}} =
               Guilds.delete_forum_category(forum_category)
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

    test "when creating a thread, the body becomes the first reply" do
      forum_category = insert(:forum_category)
      user = insert(:user)

      {:ok, forum_thread} =
        Guilds.create_forum_thread(%{
          forum_category_id: forum_category.id,
          user_id: user.id,
          title: "Test title!",
          body: "Yo!!"
        })

      assert %Guilds.ForumThread{
               forum_thread_replies: [
                 %Guilds.ForumThreadReply{
                   body: "Yo!!"
                 }
               ]
             } = forum_thread |> Repo.preload([:forum_thread_replies])
    end

    test "can pin a thread" do
      forum_thread = insert(:forum_thread)

      assert {:ok,
              %Guilds.ForumThread{
                is_pinned: true
              }} = Guilds.pin_forum_thread(forum_thread)
    end

    test "regular users cannot pin a thread" do
    end

    test "moderators can pin a thread" do
    end

    test "guild admins can pin a thread" do
    end

    test "guildship admins cannot pin a thread" do
    end

    test "can create a pinned thread" do
      forum_category = insert(:forum_category)
      user = insert(:user)

      assert {:ok,
              %Guilds.ForumThread{
                title: "test",
                is_pinned: true
              }} =
               Guilds.create_forum_thread(%{
                 forum_category_id: forum_category.id,
                 user_id: user.id,
                 title: "test",
                 is_pinned: true,
                 body: "test"
               })
    end

    test "can lock a thread" do
      forum_thread = insert(:forum_thread)

      assert {:ok,
              %Guilds.ForumThread{
                is_locked: true
              }} = Guilds.lock_forum_thread(forum_thread)
    end

    test "regular users cannot lock a thread" do
    end

    test "moderators can lock a thread" do
    end

    test "guild admins can lock a thread" do
    end

    test "guildship admins cannot lock a thread" do
    end

    test "can create a locked thread" do
      forum_category = insert(:forum_category)
      user = insert(:user)

      assert {:ok,
              %Guilds.ForumThread{
                title: "test",
                is_locked: true
              }} =
               Guilds.create_forum_thread(%{
                 forum_category_id: forum_category.id,
                 user_id: user.id,
                 title: "test",
                 is_locked: true,
                 body: "test"
               })
    end

    test "regular members cannot reply to a locked thread" do
    end

    test "guild moderators can reply to locked threads" do
    end

    test "guild admins can reply to locked threads" do
    end

    test "guildship admins can reply to locked threads" do
    end

    test "can edit a thread" do
      forum_thread = insert(:forum_thread, title: "Not Edited")

      assert {:ok, %Guilds.ForumThread{title: "Edited"}} =
               Guilds.edit_forum_thread(forum_thread, %{title: "Edited"})
    end

    test "regular members cannot edit a thread they didn't create" do
    end

    test "guild moderators can edit a thread in a guild they moderate" do
    end

    test "guild moderators cannot edit a thread in a guild they don't moderate" do
    end

    test "guild admins cannot edit a thread in a guild they aren't admin of" do
    end

    test "guildship admins can edit threads" do
    end

    test "can delete a thread" do
      forum_thread = insert(:forum_thread)

      assert {:ok, %Guilds.ForumThread{}} =
               Guilds.delete_forum_thread(forum_thread)
    end

    test "regular members cannot delete threads" do
    end

    test "guild moderators can delete threads" do
    end

    test "guild admins can delete threads" do
    end

    test "guild moderators cannot delete a thread in a guild they don't moderate" do
    end

    test "guild admins cannot delete a thread in a guild they aren't admin of" do
    end

    test "guildship admins can delete threads" do
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
      user = insert(:user)
      guild = insert(:guild)
      today = Date.utc_today()
      {:ok, start_time} = Time.new(12, 0, 0)

      assert {:error, _} =
               Guilds.create_calendar_event(%{
                 user_id: user.id,
                 guild_id: guild.id,
                 title: "test",
                 start_date: today,
                 start_time: start_time,
                 end_date: today
               })
    end

    test "cannot create an event if not given an end date" do
      user = insert(:user)
      guild = insert(:guild)
      today = Date.utc_today()

      assert {:error, _} =
               Guilds.create_calendar_event(%{
                 user_id: user.id,
                 guild_id: guild.id,
                 title: "test",
                 start_date: today
               })
    end

    test "can edit an event" do
      event = insert(:calendar_event, title: "Unedited")

      assert {:ok, %Guilds.CalendarEvent{title: "Edited"}} =
               Guilds.edit_calendar_event(event, %{title: "Edited"})
    end

    test "regular users can't edit an event" do
    end

    test "guild moderators can edit an event" do
    end

    test "guild admins can edit an event" do
    end

    test "guildship admins can edit an event" do
    end

    test "can delete an event" do
      event = insert(:calendar_event)

      assert {:ok, %Guilds.CalendarEvent{}} =
               Guilds.delete_calendar_event(event)
    end

    test "regular users can't delete an event" do
    end

    test "guild moderators can delete an event" do
    end

    test "guild admins can delete an event" do
    end

    test "guildship admins can delete an event" do
    end
  end

  describe "Guild Blog" do
    test "can create a blog post" do
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

    test "can edit a blog post" do
      blog_post = insert(:guild_blog_post, title: "Unedited", body: "Unedited")

      assert {:ok, %Guilds.GuildBlogPost{title: "Edited", body: "Edited"}} =
               Guilds.edit_guild_blog_post(blog_post, %{
                 title: "Edited",
                 body: "Edited"
               })
    end

    test "regular users can't edit a blog post" do
    end

    test "guild moderators can edit a blog post" do
    end

    test "guild admins can edit a blog post" do
    end

    test "guildship admins can edit a blog post" do
    end

    test "can delete a blog post" do
      blog_post = insert(:guild_blog_post)

      assert {:ok, _} = Guilds.delete_guild_blog_post(blog_post)
    end

    test "regular users can't delete a blog post" do
    end

    test "guild moderators can delete a blog post" do
    end

    test "guild admins can delete a blog post" do
    end

    test "guildship admins can delete a blog post" do
    end
  end

  describe "Reactions" do
    test "can react to a blog post" do
      %{id: resource_id} = blog_post = insert(:guild_blog_post)
      %{id: user_id} = user = insert(:user)

      assert {:ok,
              %Guilds.Reaction{
                user_id: user_id,
                reactionable_id: resource_id,
                emoji_name: "boop"
              }} =
               Guilds.add_reaction(blog_post, %{
                 emoji_name: "boop",
                 user_id: user.id
               })
    end

    test "cannot create duplicate reaction to a blog post" do
      user = insert(:user)
      resource = insert(:guild_blog_post)

      {:ok, _} =
        Guilds.add_reaction(resource, %{
          user_id: user.id,
          emoji_name: "boop"
        })

      assert {:error, _} =
               Guilds.add_reaction(resource, %{
                 user_id: user.id,
                 emoji_name: "boop"
               })
    end

    test "can remove a blog post reaction" do
      resource = insert(:guild_blog_post)
      user = insert(:user)

      {:ok, reaction} =
        Guilds.add_reaction(resource, %{
          emoji_name: "boop",
          user_id: user.id
        })

      assert {:ok, %Guilds.Reaction{}} = Guilds.remove_reaction(reaction)
    end

    test "users who reacted to a blog post can remove their reaction" do
    end

    test "guild moderators cannot remove someone else's reaction to a blog post" do
    end

    test "guild admins cannot remove someone else's reaction to a blog post" do
    end

    test "guildship admins cannot remove someone else's reaction to a blog post" do
    end

    test "can react to a forum thread reply" do
      %{id: resource_id} = forum_thread_reply = insert(:forum_thread_reply)
      %{id: user_id} = user = insert(:user)

      assert {:ok,
              %Guilds.Reaction{
                user_id: user_id,
                reactionable_id: resource_id,
                emoji_name: "thinking_face"
              }} =
               Guilds.add_reaction(forum_thread_reply, %{
                 user_id: user.id,
                 emoji_name: "thinking_face"
               })
    end

    test "cannot create duplicate reaction to a forum thread reply" do
      user = insert(:user)
      resource = insert(:forum_thread_reply)

      {:ok, _} =
        Guilds.add_reaction(resource, %{
          user_id: user.id,
          emoji_name: "boop"
        })

      assert {:error, _} =
               Guilds.add_reaction(resource, %{
                 user_id: user.id,
                 emoji_name: "boop"
               })
    end

    test "can remove a forum thread reply reaction" do
      resource = insert(:forum_thread_reply)
      user = insert(:user)

      {:ok, reaction} =
        Guilds.add_reaction(resource, %{
          emoji_name: "boop",
          user_id: user.id
        })

      assert {:ok, %Guilds.Reaction{}} = Guilds.remove_reaction(reaction)
    end

    test "users who reacted to a forum thread reply can remove their reaction" do
    end

    test "guild moderators cannot remove someone else's reaction to a forum thread reply" do
    end

    test "guild admins cannot remove someone else's reaction to a forum thread reply" do
    end

    test "guildship admins cannot remove someone else's reaction to a forum thread reply" do
    end

    test "cannot react to a forum thread reply if the thread is locked" do
    end

    test "can react to a calendar event" do
      %{id: resource_id} = calendar_event = insert(:calendar_event)
      %{id: user_id} = user = insert(:user)

      assert {:ok,
              %Guilds.Reaction{
                user_id: user_id,
                reactionable_id: resource_id,
                emoji_name: "tada"
              }} =
               Guilds.add_reaction(calendar_event, %{
                 user_id: user.id,
                 emoji_name: "tada"
               })
    end

    test "cannot create duplicate reaction to a calendar event" do
      user = insert(:user)
      resource = insert(:calendar_event)

      {:ok, _} =
        Guilds.add_reaction(resource, %{
          user_id: user.id,
          emoji_name: "boop"
        })

      assert {:error, _} =
               Guilds.add_reaction(resource, %{
                 user_id: user.id,
                 emoji_name: "boop"
               })
    end

    test "can remove a calendar event reaction" do
      resource = insert(:calendar_event)
      user = insert(:user)

      {:ok, reaction} =
        Guilds.add_reaction(resource, %{
          emoji_name: "boop",
          user_id: user.id
        })

      assert {:ok, %Guilds.Reaction{}} = Guilds.remove_reaction(reaction)
    end

    test "users who reacted to a calendar event can remove their reaction" do
    end

    test "guild moderators cannot remove someone else's reaction to a calendar event" do
    end

    test "guild admins cannot remove someone else's reaction to a calendar event" do
    end

    test "guildship admins cannot remove someone else's reaction to a calendar event" do
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

      assert [%Guilds.Membership{user_id: ^user_id, role: "admin"}] =
               guild.guild_memberships
    end

    test "guild moderators cannot make a regular member a moderator" do
    end

    test "guild moderators cannot remove another moderator from the their guild" do
    end

    test "guild admins can promote regular members to moderator" do
    end

    test "guild admins can demote moderators" do
    end

    test "guild admins can remove regular members from the guild" do
    end

    test "guild admins can remove guild moderators from the guild" do
    end

    test "guild admins can remove guild admins from the guild" do
    end
  end
end
