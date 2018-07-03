defmodule LsnmWeb.SearchController do
  use LsnmWeb, :controller
  alias Lsnm.Specials
  alias Lsnm.Users
  @multi_search_terms [" and ", " or ", ",", " with "]

  def results(conn, %{"pagination_token" => pagination_token}) do
    {:ok, response} = place_search(pagination_token)
    render(conn, "paginated_results.json", results: response)
  end

  def results(conn, body) do
    geocoords = geocoords_from_address(body["location"] |> String.replace(",", " "))
    keyword = if (body["keyword"] == "null" || is_nil(body["keyword"])), do: "", else: body["keyword"]
    case place_search(geocoords, radius_converter(body["radius"]), URI.decode_www_form(keyword)) do
      {:ok, response} ->
        render(conn, "results.json", results: response, geocoords: geocoords)
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
      {:ok, _} ->
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

  def autocomplete(conn, %{"location" => location, "radius" => radius, "keyword" => keyword}) do
    case autocomplete(geocoords_from_address(location), radius_converter(radius), keyword) do
      {:ok, resp} ->
        render(conn, "autocomplete_results.json", autocomplete_results: resp["predictions"])
      _ ->
        json(conn, %{:body => %{"status" => "error"}})
    end
  end

  defp autocomplete(location, radius, keyword) do
    GoogleMaps.place_autocomplete(keyword, [location: location, radius: radius, strictbounds: true])
  end

  defp geocoords_from_address(location) do
    {:ok, %{"results" => [result|_]}} = GoogleMaps.geocode(location)
    %{"lat" => lat, "lng" => lng} = result["geometry"]["location"]
    "#{lat},#{lng}"
  end

  defp place_search(pagination_token) do
    GoogleMaps.place_nearby("", "", [pagetoken: pagination_token])
  end

  def place_search(geocoords, radius, keyword) do
    if String.contains?(keyword, @multi_search_terms) do
      multi_place_search(geocoords, radius, keyword)
     else
      GoogleMaps.place_nearby(geocoords, radius,[keyword: keyword, type: "restaurant"])
    end
  end

  defp multi_place_search(geocoords, radius, keyword) do
    results = 
    String.split(keyword, @multi_search_terms)
    |> Enum.flat_map(fn term -> 
      case place_search(geocoords, radius, term) do
        {:ok, results} -> results["results"]
        {:error, "ZERO_RESULTS"} -> []
      end
    end)
    |> Enum.shuffle()
    {:ok, %{"results" => results, "status" => "OK", "html_attributions" => []}}
  end

  defp radius_converter(radius) when is_bitstring(radius), do: radius_converter(String.to_integer(radius))
  defp radius_converter(radius), do: radius * 1609

end