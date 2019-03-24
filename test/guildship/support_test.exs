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
      resource = insert(:forum_thread_reply)

      {:ok,
       %Support.Flag{
         flaggable_id: resource.id
       }} == Support.flag_content(resource)
    end

    test "can flag a user" do
      resource = insert(:user)

      {:ok,
       %Support.Flag{
         flaggable_id: resource.id
       }} == Support.flag_content(resource)
    end
  end
end
