defmodule Guildship.GuildTest do
  use Guildship.DataCase, async: true
  alias Guildship.Guilds

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

    test "can create a news post" do
      guild = insert(:guild)
      user = insert(:user)

      assert {:ok,
              %Guilds.GuildNewsPost{
                user: user,
                guild: guild,
                title: "Howdy Everyone!",
                body: "Wazzap!"
              }} =
               Guilds.create_guild_news_post(%{
                 user_id: user.id,
                 guild_id: guild.id,
                 title: "Howdy Everyone!",
                 body: "Wazzap!"
               })
    end
  end

  describe "Guild Calendar" do
  end

  describe "Guild News" do
  end
end
