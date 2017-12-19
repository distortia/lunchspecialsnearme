defmodule LsnmWeb.SearchCommander do
  use Drab.Commander

  def show_more_places(socket, sender) do
    results = Drab.Live.peek(socket, :results)
    next_page_token = Drab.Live.peek(socket, :next_page_token)
    unless is_nil(next_page_token) do
      {:ok, new_response} = GoogleMaps.place_nearby("", 0, [pagetoken: next_page_token])
      Drab.Live.poke(socket, [results: results ++ new_response["results"], next_page_token: new_response["next_page_token"]])
      create_markers(socket)
      if is_nil(Drab.Live.peek(socket, :next_page_token)), do: no_next_page(socket)
    end
  end

  def no_next_page(socket) do
    set_prop socket, ".show-more-btn", innerHTML: "No More results", classList: "btn btn-block show-more-btn btn-warning", disabled: true
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
    if is_nil(Drab.Live.peek(socket, :next_page_token)), do: no_next_page(socket)
  end
end
