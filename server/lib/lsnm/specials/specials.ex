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
    Repo.get_by!(Special, place_id: place_id)
  end

  def add(special) do
    %Special{}
    |> Special.changeset(special)
    |> Repo.insert
  end

  def edit(special) do
    Repo.get!(Special, special["id"])
    |> Special.changeset(special)
    |> Repo.update
  end
end
