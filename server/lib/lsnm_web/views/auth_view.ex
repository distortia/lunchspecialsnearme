defmodule LsnmWeb.AuthView do
  use LsnmWeb, :view

  def render("login.json", %{user: user, jwt: jwt, exp: exp}) do
    %{user: render_one(user, LsnmWeb.UserView, "user.json"), jwt: jwt, exp: exp}
  end

  def render("logout.json", _params) do
    %{status: "ok"}
  end

end
