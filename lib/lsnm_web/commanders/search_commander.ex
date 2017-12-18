defmodule LsnmWeb.SearchCommander do
  use Drab.Commander

  def show_more_places(socket, sender) do
    results = Drab.Live.peek(socket, :results)
    next_page_token = Drab.Live.peek(socket, :next_page_token)
    {:ok, new_response} = GoogleMaps.place_nearby("", 0, [pagetoken: next_page_token])
    Drab.Live.poke(socket, results: results ++ new_response["results"])
    create_markers(socket)
  end

  onload :page_loaded
  
  def init_map(socket) do
    [lat, lng] = String.split(Drab.Live.peek(socket, :geocoords), ",")
    socket |> exec_js("initMap(#{lat}, #{lng})", timeout: 10_000)
  end

  def create_markers(socket) do
    Drab.Live.peek(socket, :results)
    |> Enum.with_index
    |> Enum.each(
      fn {result, index} ->
        exec_js(socket, "createMarker(#{Poison.encode!(result)}, #{index})", timeout: 10_000)
    end)
  end

  def page_loaded(socket) do
    init_map(socket)
    create_markers(socket)
  end
end
