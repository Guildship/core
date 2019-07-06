defmodule GuildshipWeb.HealthcheckTest do
  use GuildshipWeb.ConnCase, async: true

  test "it works" do
    conn = build_conn() |> get("/health")
    body = conn |> response(200)

    assert body == "healthy"
  end
end
