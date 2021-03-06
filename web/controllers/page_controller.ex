defmodule Marc.PageController do
  use Marc.Web, :controller

  def index(conn, _params) do
    chapter_view = Marc.Meditations.random_short_chapter()
    render conn, "index.html", chapter_view: chapter_view
  end

  def random_chapter(conn, _params) do
    chapter_view = Marc.Meditations.random_chapter()
    render conn, "random_chapter.html", chapter_view: chapter_view
  end

  def chapter(conn, %{"chapter_number" => num}) do
    case Integer.parse(num) do
      :error ->
        render conn, "chapter_not_found.html"
      {parsed_num, _rest} ->
        case Marc.Meditations.get_chapter_by_number(parsed_num) do
          nil ->
            render conn, "chapter_not_found.html"
          chapter_view ->
            render conn, "chapter.html", chapter_view: chapter_view
        end
    end
  end

  def meditations_full(conn, _params) do
    meditations = Marc.Meditations.meditations()
    render conn, "meditations_full.html", %{
      meditations: meditations
    }
  end

  def meditations_markdown(conn, _params) do
    markdown_text = Marc.Meditations.markdown()
    text conn, markdown_text
  end

  def meditations_json(conn, _params) do
    json_data = Marc.Meditations.json
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json_data)
  end

  def about(conn, _params) do
    render conn, "about.html"
  end

  def status(conn, _params) do
    text conn, "ok"
  end
end
