defmodule Lsnm.Special do
  use Lsnm.Web, :model

  schema "specials" do

    field :place_id, :string
    field :days_of_week, {:array, :string}
    field :info, :text
    field :reoccuring, :boolean

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
