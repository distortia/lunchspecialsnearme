defmodule LsnmWeb.SearchController do
  use LsnmWeb, :controller
  alias Lsnm.Specials
  alias Lsnm.Users

  def results(conn, %{"pagination_token" => pagination_token}) do
    {:ok, response} = place_search(pagination_token)
    render(conn, "paginated_results.json", results: response)
  end

  def results(conn, body) do
    geocoords = geocoords_from_address(body["location"] |> String.replace(",", " "))
    radius = String.to_integer(body["radius"]) * 1609
    keyword = if (body["keyword"] == "null" || is_nil(body["keyword"])), do: "", else: body["keyword"]
    case place_search(geocoords, radius, URI.decode_www_form(keyword)) do
      {:ok, response} -> render(conn, "results.json", results: response, geocoords: geocoords)
      {:error, "ZERO_RESULTS"} -> json(conn, %{error: "ZERO_RESULTS", geocoords: geocoords})
      _ -> send_resp(conn, 404, "Not found")
    end   
  end

  @doc """
  Fetchs the place detials for the given place_id
  """
  def details(conn, body) do
    {:ok, response} =
    body["place_id"]
    |> GoogleMaps.place_details()
    render(conn, "details.json", details: response)
  end

  @doc """
  Fetches the special for the given `place_id`.

  Returns the json response for the place if it exists

  Or 404 if it doesnt.
  """
  def special(conn, body) do
    specials = Specials.special(body["place_id"])
    case length(specials) do
      0 -> send_resp(conn, 404, "Not found")
      _ -> render(conn, "specials.json", specials: specials)
    end
  end

  def add(conn, body) do
    case Specials.add(body) do
      true ->
        Users.update_stats(body["user_id"], :specials_added, length(body["days_of_week"]))
        json(conn, %{:body => %{"status" => "ok"}})
      false ->
        json(conn, %{:body => %{"status" => "error"}})
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

  def delete(conn, %{"id" => id}) do
    Specials.delete(id)
    json(conn, %{:body => %{"status" => "ok"}})
  end

  def user_specials(conn, user_id) do
    render(conn, "specials.json", specials: Specials.user_specials(user_id))
  end

  def location(conn, %{"location" => location}) do
    {:ok, %{"results" => [result|_]}} = GoogleMaps.geocode(location)
    address = result["formatted_address"] |> String.split(",") |> List.delete_at(-1) |> List.to_string
    json(conn, %{:location => result["geometry"]["location"], :address => address})
  end

  defp geocoords_from_address(location) do
    {:ok, %{"results" => [result|_]}} = GoogleMaps.geocode(location)
    %{"lat" => lat, "lng" => lng} = result["geometry"]["location"]
    "#{lat},#{lng}"
  end

  defp place_search(pagination_token) do
    GoogleMaps.place_nearby("", "", [pagetoken: pagination_token])
  end

  defp place_search(geocoords, radius, keyword) do
    GoogleMaps.place_nearby(geocoords, radius,[keyword: keyword, type: "restaurant", opennow: "true"])
  end

end