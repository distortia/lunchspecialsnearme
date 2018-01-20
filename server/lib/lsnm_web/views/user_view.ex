defmodule LsnmWeb.UserView do
  use LsnmWeb, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, LsnmWeb.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      username: user.username,
      stats: user.stats}
  end

end
