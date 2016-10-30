defmodule Marc.PageController do
  use Marc.Web, :controller

  def index(conn, _params) do
    chapter_view = Marc.Meditations.random_chapter
    render conn, "index.html", chapter_view: chapter_view
  end

  def chapter(conn, %{"index" => index}) do
    case Integer.parse(index) do
      :error ->
        render conn, "chapter_not_found.html"
      {parsed_index, _rest} ->
        case Marc.Meditations.get_chapter_by_index(parsed_index) do
          nil ->
            render conn, "chapter_not_found.html"
          chapter_view ->
            render conn, "chapter.html", chapter_view: chapter_view
        end
    end

  end

  def about(conn, _params) do
    render conn, "about.html"
  end

  def status(conn, _params) do
    text conn, "ok"
  end
end
