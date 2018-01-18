defmodule LsnmWeb.AuthHandler do

  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias Plug.Conn

  def login_by_email_and_pass(user, pass) do
    if user && checkpw(pass, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid}
    end
  end

end
