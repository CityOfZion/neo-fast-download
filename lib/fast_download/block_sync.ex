defmodule FastDownload.BlockSync do
  @moduledoc false

  @moduledoc """

    External process to fetch blockchain from RCP node and sync the database

  """

  alias FastDownload.Blockchain


  #Evaluates db against external blockchain and route required functions
  def start(n) do
    { :ok, path } = File.cwd
    file = File.open!("#{path}/chain.json", [:append, :utf8])
    IO.write(file,"[")
    evaluate(file, n, 0)
  end

  defp evaluate(file, n, count) do
    case Blockchain.get_current_height(Enum.random(0..4)) do
      {:ok, height} when (height-2) > count  ->
        cond do
          (height-2) - count >= n ->
            Enum.to_list(count..(count+n-1))
            |> Enum.map(&Task.async(fn -> cross_check(&1) end))
            |> Enum.map(&Task.await(&1, 10000))
            |> Enum.map(fn x -> add_block(x, file, height-2) end)
            evaluate(file, n, count+n)
          (height-2) - count < n ->
            Enum.to_list(count..(height-2))
            |> Enum.map(&Task.async(fn -> cross_check(&1) end))
            |> Enum.map(&Task.await(&1, 10000))
            |> Enum.map(fn x -> add_block(x, file, height-2) end)
            IO.write(file, "]")
            Process.exit(self(), :normal)
        end
      {:ok, height} when (height-2) == count  ->
        IO.write(file, "]")
        Process.exit(self(), :normal)
      { :error, reason} ->
        IO.puts("Failed to get current height from chain, result =#{reason}")
        Process.exit(self(), :error)
    end
  end

  #add block with transactions to the db
  def add_block(%{"index" => num} = block, file, height) do
    map = %{"index" => num, "block" => block}
    IO.write(file, Poison.encode!(map))
    if num != height do
      IO.write(file, ",")
    end
    IO.puts("Block #{num} saved")
  end

  def cross_check(height) do
    random1 = Enum.random(0..4)
    cond do
      random1 == 4 ->
        random2 = 1
      true ->
        random2 = random1 + 1
    end
    blockA = get_block_by_height(random1, height)
    blockB = get_block_by_height(random2, height)
    %{"hash" => hashA} = blockA
    %{"hash" => hashB} = blockB
    cond do
      hashA == hashB ->
        blockA
      true ->
        cross_check(height)
    end
  end
  #handles error when fetching highest block from chain
  def get_block_by_height(random, height) do
    case Blockchain.get_block_by_height(random, height) do
      { :ok , block } ->
        IO.inspect(block)
        block
      { :error, _reason} ->
        get_block_by_height(random, height)
    end
  end

end
