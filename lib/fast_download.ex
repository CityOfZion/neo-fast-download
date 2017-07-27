defmodule FastDownload do
  defdelegate start(n), to: FastDownload.BlockSync, as: :start
end
