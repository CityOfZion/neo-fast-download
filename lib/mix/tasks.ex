defmodule Mix.Tasks.FastDownload.Run do
  use Mix.Task

  def run([n]) do
    {:ok, _started} = Application.ensure_all_started(:httpoison)
    FastDownload.start(n)
  end

end
