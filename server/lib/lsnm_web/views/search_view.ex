defmodule LsnmWeb.SearchView do
  use LsnmWeb, :view

  def render("results.json", %{results: results}) do
    %{data: results}
  end

  @doc """
  Renders the special data we want from the database into json format.
  """
  def render("specials.json", %{specials: specials}) do
   %{data: render_many(specials, LsnmWeb.SearchView, "special.json")}
  end

  def render("special.json", %{search: search}) do
     %{
      :day_of_week => search.day_of_week,
      :info => search.info,
      :place_id => search.place_id
      }
  end

  def render("details.json", %{details: details}) do
    details = details["result"]
    %{data: %{
        :phoneNumber => details["international_phone_number"],
        :address => details["formatted_address"],
        :title => details["name"],
        :price_level => details["price_level"],
        :rating => details["rating"],
        :website => details["website"],
        :review => details["reviews"],
        :photos => details["photos"],
        :url => details["url"],
        :place_id => details["place_id"],
        :openingHours => details["opening_hours"]["weekday_text"]
      }}
  end

end
