defmodule LsnmWeb.SearchController do
  use LsnmWeb, :controller

  def index(conn, params = %{"search" => %{"location" => location, "radius" => radius, "keyword" => keyword}}) do
    {:ok, geolocation} = GoogleMaps.geocode(location)
    geocoords = "#{List.first(geolocation["results"])["geometry"]["location"]["lat"]},#{List.first(geolocation["results"])["geometry"]["location"]["lng"]}"
    {:ok, response} =
    geocoords
    |> GoogleMaps.place_nearby(String.to_integer(radius) * 1609, [keyword: keyword, type: "restaurant", opennow: "true"])
    render(conn, "search.html", next_page_token: response["next_page_token"], results: response["results"], geocoords: geocoords)
  end

  def results(conn, params) do
    {:ok, response} =
    "#{params["location"]["lat"]},#{params["location"]["lng"]}"
    |> GoogleMaps.place_nearby(
      String.to_integer(params["radius"]) * 1609,
      [keyword: params["keyword"],
      type: "restaurant",
      opennow: "true"])
    render(conn, "results.json", results: response)
  end

end