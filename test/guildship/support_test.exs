defmodule Guildship.SupportTest do
  use Guildship.DataCase, async: true
  alias Guildship.Support

  describe "Feedback" do
    test "can provide feedback when not logged in" do
      assert {:ok,
              %Support.Feedback{
                message: "This app suxxorz!"
              }} =
               Support.send_feedback(%{
                 message: "This app suxxorz!"
               })
    end

    test "can provide feedback when logged in" do
      user = insert(:user)

      assert {:ok,
              %Support.Feedback{
                user: user,
                message: "how to delete ur app from the internet?"
              }} =
               Support.send_feedback(%{
                 user_id: user.id,
                 message: "how to delete ur app from the internet?"
               })
    end
  end

  describe "Flagging" do
    test "can flag a forum thread reply" do
      %{id: resource_id} = resource = insert(:forum_thread_reply)

      assert {:ok,
              %Support.Flag{
                flaggable_id: ^resource_id
              }} = Support.flag_content(resource)
    end

    test "can flag a user" do
      %{id: resource_id} = resource = insert(:user)

      assert {:ok,
              %Support.Flag{
                flaggable_id: ^resource_id
              }} = Support.flag_content(resource)
    end

    test "can flag a blog post" do
      %{id: resource_id} = resource = insert(:guild_blog_post)

      assert {:ok,
              %Support.Flag{
                flaggable_id: ^resource_id
              }} = Support.flag_content(resource)
    end

    test "can flag a guild" do
    end
  end
end
