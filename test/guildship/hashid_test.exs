defmodule Guildship.HashIDTest do
  use ExUnit.Case

  test "it can encode positive integers" do
    assert is_binary(Guildship.HashID.encode(1))
  end

  test "it can decode hashids" do
    hashid = Guildship.HashID.encode(1)
    assert 1 = Guildship.HashID.decode(hashid)
  end
end
