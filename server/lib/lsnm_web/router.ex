defmodule LsnmWeb.Router do
  use LsnmWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, [origin: "http://localhost:8080"]
    plug :accepts, ["json"]
  end

  scope "/", LsnmWeb do
    pipe_through :browser # Use the default browser stack

    # get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", LsnmWeb do
    pipe_through :api
    post "/email/feedback", EmailController, :feedback
    options "/email/feedback", EmailController, :nothing
    get "/special/:place_id", SearchController, :special
    options "/special/:place_id", SearchController, :nothing
    post "/special/add", SearchController, :add
    options "/special/add", SearchController, :nothing
    put "/special/edit/:id", SearchController, :edit
    options "/special/edit/:id", SearchController, :nothing
    delete "/special/delete/:id", SearchController, :delete
    options "/special/delete/:id", SearchController, :nothing
    post "/results", SearchController, :results
    options "/results", SearchController, :nothing
    get "/results/details/:place_id", SearchController, :details
    options "/results/details/:place_id", SearchController, :nothing
  end
end
