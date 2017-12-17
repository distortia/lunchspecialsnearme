defmodule LsnmWeb.PageController do
  use LsnmWeb, :controller
  use Drab.Controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
