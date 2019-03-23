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
    end
  end

  describe "Flagging" do
    test "can flag content when not logged in" do
    end

    test "can flag content when logged in" do
    end
  end
end
