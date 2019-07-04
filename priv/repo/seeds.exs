import Guildship.Factory
alias Guildship.Repo

# Only run guild seed if there are no guilds
with [] <- Repo.all(Guildship.Guilds.Guild) do
  for _ <- 1..50 do
    guild = insert(:guild)
  end
end
