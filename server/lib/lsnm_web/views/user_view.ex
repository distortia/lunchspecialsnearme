defmodule LsnmWeb.UserView do
  use LsnmWeb, :view

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      username: user.username,
      stats: user.stats}
  end

end
