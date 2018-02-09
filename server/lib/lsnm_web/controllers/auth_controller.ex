defmodule LsnmWeb.AuthController do
  use LsnmWeb, :controller

  alias LsnmWeb.Guardian
  alias Lsnm.Users
  alias LsnmWeb.AuthHandler

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    user = Users.user(email)
    case AuthHandler.login_by_email_and_pass(user, password) do
      {:ok, user} -> 
        new_conn = Guardian.Plug.sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        %{"exp" => exp} = Guardian.Plug.current_claims(new_conn)

        new_conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> render("login.json", user: user, jwt: jwt, exp: exp) 
      {:error, _invalid} ->
        conn
        |> put_status(401)
    end
  end

  def login(conn, _params) do
    send_resp(conn, 401, Poison.encode!(%{error: "Incorrect email or password"}))
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> send_resp(204, "")
  end

  def show(conn, params) do
    IO.puts "HERE"
    IO.inspect params
    user = Guardian.Plug.current_resource(conn)
    send_resp(conn, 200, Poison.encode!(%{user: user}))
  end

end
