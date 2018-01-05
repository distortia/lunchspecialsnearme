defmodule Lsnm.Repo.Migrations.CreateSpecial do
  use Ecto.Migration

  def change do
    create table(:specials) do

      add :place_id, :string
      add :days_of_week, {:array, :string}, default: []
      add :info, :text
      add :reoccuring, :boolean

      timestamps()
    end
  end
end
