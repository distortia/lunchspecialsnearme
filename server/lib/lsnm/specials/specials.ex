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
end
