defmodule Marc.Router do
  use Marc.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Marc do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/random", PageController, :random_chapter
    get "/c/:chapter_number", PageController, :chapter

    get "/meditations", PageController, :meditations_full
    get "/meditations.md", PageController, :meditations_markdown
    get "/meditations.json", PageController, :meditations_json

    get "/about", PageController, :about
    get "/status", PageController, :status
  end

  # Other scopes may use custom stacks.
  # scope "/api", Marc do
  #   pipe_through :api
  # end
end
