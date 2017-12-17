defmodule LsnmWeb.SearchController do
  use LsnmWeb, :controller
  use Drab.Controller

  def index(conn, params = %{"search" => %{"location" => location, "radius" => radius, "keyword" => keyword}}) do
    radius = String.to_integer(radius) * 1609
    {:ok, response} = GoogleMaps.place_nearby(location, radius, [keyword: keyword, type: "restaurant", opennow: "true"])
    render(conn, "search.html", next_page_token: response["next_page_token"], results: response["results"])
  end

end