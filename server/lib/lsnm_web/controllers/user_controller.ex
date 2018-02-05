defmodule LsnmWeb.UserController do
  use LsnmWeb, :controller
  alias Lsnm.Users
  alias Lsnm.Specials

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

  def update(conn, %{"user" => user_params}) do
    case Users.update(user_params) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LsnmWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end