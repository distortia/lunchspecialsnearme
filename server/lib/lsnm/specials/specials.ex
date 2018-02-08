defmodule Lsnm.Specials do
  import Ecto.Query, warn: false
  alias Lsnm.Repo

  alias Lsnm.Specials.Special
  alias Lsnm.Users

  @moduledoc """
  Specials is an abstraction over %Special{}.
  This is where we list all of our methods to interact with out specials.
  """

  def list_specials do
    Repo.all(Special)
  end

  def special(place_id) do
    Repo.all(from s in "specials",
            where: s.place_id == ^place_id,
            select: %{day_of_week: s.day_of_week,
                      place_id: s.place_id,
                      info: s.info,
                      name: s.name,
                      id: s.id})
  end

  def add(special) do
    Enum.all?(special["days_of_week"], fn day -> 
      daily_special = %{
        day_of_week: day,
        place_id: special["place_id"],
        info: special["info"],
        name: special["name"],
        user_id: special["user_id"]
      }
      %Special{}
      |> Special.changeset(daily_special)
      |> Repo.insert()
    end)
  end

  def edit(special) do
    Repo.get!(Special, special["id"])
    |> Special.changeset(special)
    |> Repo.update
  end

  def delete(id) do
    Repo.get!(Special, id)
    |> Repo.delete!
  end

  def user_specials(%{"user_id" => user_id}) do
    Repo.all(from s in "specials", where: s.user_id == ^String.to_integer(user_id), select: %{
      name: s.name,
      place_id: s.place_id,
      day_of_week: s.day_of_week,
      info: s.info,
      id: s.id
      })
  end
end
