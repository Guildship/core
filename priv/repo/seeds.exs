import Guildship.Factory

users = 1..250 |> MapSet.new() |> Enum.map(fn _ -> insert(:user) end)

for _ <- 1..Enum.random(20..50) do
  guild = insert(:guild)

  for _ <- 1..Enum.random(1..5) do
    category = insert(:forum_category, guild: guild)

    for _ <- 1..Enum.random(5..10) do
      thread =
        insert(:forum_thread,
          guild: guild,
          forum_category: category,
          user: Enum.random(users)
        )

      for _ <- 1..Enum.random(15..50) do
        components = build_list(Enum.random(1..5), :markdown_component)

        insert(:forum_thread_reply,
          forum_thread: thread,
          components: components,
          user: Enum.random(users)
        )
      end
    end
  end
end
