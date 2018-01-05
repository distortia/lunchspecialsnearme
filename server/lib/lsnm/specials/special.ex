defmodule Lsnm.Specials.Special do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lsnm.Specials.Special

  schema "specials" do

    field :place_id, :string
    field :days_of_week, {:array, :string}
    field :info, :string
    field :reoccuring, :boolean

    timestamps()
  end

  @doc false
  def changeset(%Special{} = special, attrs) do
    special
    |> cast(attrs, [:place_id, :days_of_week, :info, :reoccuring])
    |> validate_required([:place_id, :days_of_week, :info, :reoccuring])
  end

end