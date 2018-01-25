defmodule Lsnm.Specials do
  import Ecto.Query, warn: false
  alias Lsnm.Repo

  alias Lsnm.Specials.Special

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
                      info: s.info})
  end

  def add(special) do
    Enum.each(special["days_of_week"], fn day -> 
      daily_special = %{day_of_week: day, place_id: special["place_id"], info: special["info"]}
      %Special{}
      |> Special.changeset(daily_special)
      |> Repo.insert
    end)
    {:ok, special}
  end

  def edit(special) do
    Repo.get!(Special, special["id"])
    |> Special.changeset(special)
    |> Repo.update
  end

  def delete(special) do
    Repo.get!(Special, special["id"])
    |> Repo.delete!
  end
end
