defmodule GuildshipWeb.Resolvers.VersionInfo do
  @build_time DateTime.utc_now()

  def get_info(_, _, _) do
    {:ok,
     %{
       commit_sha: System.get_env("RENDER_GIT_COMMIT") || "__DEVELOPMENT__",
       build_time: @build_time,
       branch_name: System.get_env("RENDER_GIT_BRANCH") || "__DEVELOPMENT__"
     }}
  end
end
