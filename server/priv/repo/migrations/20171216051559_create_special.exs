defmodule Lsnm.Repo.Migrations.CreateSpecial do
  use Ecto.Migration

  def change do
    create table(:specials) do

      add :place_id, :string
      add :day_of_week, {:array, :string}, default: []
      add :info, :text
      add :reoccuring, :boolean

      timestamps()
    end

    create unique_index(:specials, [:place_id])
  end
end
