defmodule LsnmWeb.UserController do
  use LsnmWeb, :controller
  alias Lsnm.Users

  def register(conn, %{"user" => user_params}) do
     case Users.add(user_params) do
       {:ok, user} ->
         conn
         |> put_status(:created)
         |> render("show.json", user: user)
       {:error, changeset} ->
         conn
         |> put_status(:unprocessable_entity)
         |> render(LsnmWeb.ChangesetView, "error.json", changeset: changeset)
     end
  end

end
