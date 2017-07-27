defmodule FastDownload.Blockchain do
  use HTTPoison.Base

  @moduledoc false
  @moduledoc """
  The boundary for the Blockchain requests.
  """

  alias FastDownload.HttpCalls

  @doc """
   Get the current block height from the Blockchain through seed 'index'
  """
  def get_current_height(seed) do
    data = Poison.encode!(%{
      "jsonrpc": "2.0",
       "method": "getblockcount",
       "params": [],
       "id": 5
    })
  	headers = [{"Content-Type", "application/json"}]
    HttpCalls.request(headers, data, seed)
  end

  @doc """
   Get the current block by height through seed 'index'
  """
  def get_block_by_height(seed , height ) do
    data = Poison.encode!(%{
      "jsonrpc" => "2.0",
       "method" => "getblock",
       "params" => [ height, 1 ],
       "id" => 5
    })
    headers = [{"Content-Type", "application/json"}]
    HttpCalls.request(headers, data, seed)
  end

end
