defmodule Guildship.HashIdTest do
  use ExUnit.Case, async: true
  alias Guildship.HashId

  test "can create a hashid" do
    assert true == HashId.encode(1) |> is_binary
  end

  test "can decode a hashid" do
    assert 1 == HashId.encode(1) |> HashId.decode()
  end

  test "decoding anything other than a hashid just returns itself" do
    assert 1 == HashId.decode(1)
  end
end
