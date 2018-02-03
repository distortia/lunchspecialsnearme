defmodule Lsnm.Users do
  import Ecto.Query, warn: false
  alias Lsnm.Repo

  alias Lsnm.Users.User

  def user(user_attribute) do
    if String.contains?(user_attribute, "@") do
      Repo.get_by!(User, email: user_attribute)
    else
      Repo.get_by!(User, user_name: user_attribute)
    end
  end

  def add(user) do
    %User{}
    |> User.register_user_changeset(user)
    |> Repo.insert
  end

  def update(user) do
    Repo.get(User, user["id"])
    |> User.update_user_changeset(user)
    |> Repo.update
  end

end
