defmodule LsnmWeb.SearchController do
  use LsnmWeb, :controller
  alias Lsnm.Specials

  def index(conn, params = %{"search" => %{"location" => location, "radius" => radius, "keyword" => keyword}}) do
    {:ok, geolocation} = GoogleMaps.geocode(location)
    geocoords = "#{List.first(geolocation["results"])["geometry"]["location"]["lat"]},#{List.first(geolocation["results"])["geometry"]["location"]["lng"]}"
    {:ok, response} =
    geocoords
    |> GoogleMaps.place_nearby(String.to_integer(radius) * 1609, [keyword: keyword, type: "restaurant", opennow: "true"])
    render(conn, "search.html", next_page_token: response["next_page_token"], results: response["results"], geocoords: geocoords)
  end

  def results(conn, body) do
    {:ok, response} =
    body["location"]
    |> GoogleMaps.place_nearby(
      String.to_integer(body["radius"]) * 1609,
      [keyword: body["keyword"],
      type: "restaurant",
      opennow: "true"])
    render(conn, "results.json", results: response)
  end

  @doc """
  Fetches the special for the given `place_id`.

  Returns the json response for the place if it exists

  Or 404 if it doesnt.
  """
  def special(conn, body) do
    render(conn, "special.json", Specials.special(body["place_id"]))
  end

  def add(conn, body) do
    case Specials.add(body) do
      {:ok, special} ->
        json(conn, %{:body => %{"status" => "ok"}})
      {:error, %Ecto.Changeset{} = changeset} ->
        json(conn, %{:body => %{"status" => "error", changeset: changeset}})
    end
  end

  def edit(conn, body) do
    case Specials.edit(body) do
      {:ok, special} ->
        json(conn, %{:body => %{"status" => "ok"}})
      {:error, %Ecto.Changeset{} = changeset} ->
        json(conn, %{:body => %{"status" => "error", changeset: changeset}})
    end
  end

  def delete(conn, body) do
    Specials.delete(body)
    json(conn, %{:body => %{"status" => "ok"}})
  end

end