defmodule GuildshipWeb.UserSocketTest do
  use GuildshipWeb.ChannelCase, async: true
  alias GuildshipWeb.UserSocket

  test "id is nil" do
    %Phoenix.Socket{} = socket = socket(Phoenix.Socket)
    assert nil == UserSocket.id(socket)
  end

  test "connect/3 just returns socket" do
    socket = socket(Phoenix.Socket)
    assert {:ok, ^socket} = UserSocket.connect(%{}, socket, nil)
  end
end
