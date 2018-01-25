defmodule LsnmWeb.SearchController do
  use LsnmWeb, :controller
  alias Lsnm.Specials

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
    IO.inspect body
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