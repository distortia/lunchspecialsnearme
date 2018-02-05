defmodule Lsnm.Specials.Special do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lsnm.Specials.Special

  schema "specials" do

    field :place_id, :string
    field :day_of_week, :string
    field :info, :string
    field :reoccuring, :boolean
    field :name, :string
    belongs_to :user, Lsnm.Users.User
    
    timestamps()
  end

  @doc false
  def changeset(%Special{} = special, attrs) do
    special
    |> cast(attrs, [:place_id, :day_of_week, :info, :name, :user_id])
    |> validate_required([:place_id, :day_of_week, :info, :name, :user_id])
    |> validate_length(:place_id, min: 1) # Make sure that they arent passing in an empty string for the place_id
  end

end