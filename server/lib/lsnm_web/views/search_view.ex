defmodule LsnmWeb.SearchView do
  use LsnmWeb, :view

  def render("results.json", %{results: results}) do
    %{data: results}
  end

end
