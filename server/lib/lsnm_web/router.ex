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
    post "/email/request", EmailController, :invite
    options "/email/request", EmailController, :nothing
    get "/special/user/:user_id", SearchController, :user_specials
    options "/special/user/:user_id", SearchController, :nothing
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
    post "/login", AuthController, :login
    options "/login", AuthController, :nothing
    post "/logout", AuthController, :logout
    options "/logout", AuthController, :nothing
    get "/user/:user_id", UserController, :index
    options "/user/:user_id", UserController, :nothing
    post "/user/register", UserController, :register
    options "/user/register", UserController, :nothing
    put "/user", UserController, :update
    options "/user", UserController, :nothing
  end
end
