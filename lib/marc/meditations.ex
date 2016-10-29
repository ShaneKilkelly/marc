defmodule Marc.Meditations do
  use GenServer

  @data_file "resources/meditations.json"

  # Public API

  def random_chapter do
    GenServer.call __MODULE__, :random
  end

  def get_chapter_by_index(index) do
    GenServer.call __MODULE__, {:get_by_index, index}
  end

  # GenServer API

  def start_link do
    start_link @data_file
  end

  def start_link(data_file) do
    GenServer.start_link __MODULE__, [data_file], name: __MODULE__
  end

  def init([data_file]) do
    {:ok, raw} = File.read data_file
    {:ok, chapters} = Poison.decode raw, keys: :atoms
    {:ok, %{chapters: chapters,
            count: Enum.count(chapters)}}
  end

  def handle_call({:get_by_index, index}, _from, state) do
    chapter = get_chapter_view(state, index)
    {:reply, chapter, state}
  end

  def handle_call(:random, _from, %{count: count}=state) do
    index = :rand.uniform(count - 1)
    random_chapter = get_chapter_view(state, index)
    {:reply, random_chapter, state}
  end

  # Private Helpers
  defp get_chapter_view(%{chapters: chapters, count: count}, index) do
    case Enum.at(chapters, index) do
      nil ->
        nil
      chapter ->
        %{chapter: chapter,
          previous: if(index == 0,         do: nil, else: index - 1),
          next:     if(index == count - 1, do: nil, else: index + 1)}
    end
  end

end
