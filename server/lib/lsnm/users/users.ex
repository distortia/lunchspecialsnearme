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

  def reset(email) do
    case Repo.get_by(User, email: email) do
      nil -> nil
      user -> 
        attrs = put_in(user.temp_id, generate_temp_id()) |> Map.from_struct
        User.reset_user_changeset(user, attrs)
        |> Repo.update
    end
  end

  # TODO: Nick - flush this out and make more dynamic as we expand our stats
  def update_stats(user_id, :specials_added, amount) do
    user = Repo.get(User, user_id)
    user
    |> User.changeset(%{stats: %{"specials_added" => user.stats["specials_added"] + amount }})
    |> Repo.update()
  end

  def update_reset_password(temp_id, password) do
    user = Repo.get_by(User, temp_id: temp_id)
    user
    |> User.update_reset_changeset(%{password: password, temp_id: temp_id})
    |> Repo.update()
  end

  defp generate_temp_id do
    :crypto.strong_rand_bytes(10) |> Base.encode64 |> binary_part(0, 10)
  end
end
