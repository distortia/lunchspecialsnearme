defmodule LsnmWeb.SearchCommander do
  use Drab.Commander
  # Place your event handlers here
  #
  # def button_clicked(socket, sender) do
  #   set_prop socket, "#output_div", innerHTML: "Clicked the button!"
  # end
  #
  # Place you callbacks here
  #

  def show_more_places(socket, sender) do
    results = Drab.Live.peek(socket, :results)
    next_page_token = Drab.Live.peek(socket, :next_page_token)
    {:ok, new_response} = GoogleMaps.place_nearby("", 0, [pagetoken: next_page_token])
    Drab.Live.poke(socket, results: results ++ new_response["results"])
  end

  onload :page_loaded
  
  def page_loaded(socket) do
    set_prop socket, "div.test", innerText: "This page has been drabbed"
  end
end
