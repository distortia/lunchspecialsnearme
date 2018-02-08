defmodule Lsnm.Users do
  import Ecto.Query, warn: false
  alias Lsnm.Repo

  alias Lsnm.Users.User

  def get_by_id(user_id) do
    Repo.get!(User, user_id)
  end

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

  # TODO: Nick - flush this out and make more dynamic as we expand our stats
  def update_stats(user_id, :specials_added, amount) do
    user = Repo.get(User, user_id)
    user
    |> User.changeset(%{stats: %{"specials_added" => user.stats["specials_added"] + amount }})
    |> Repo.update()
  end
end
