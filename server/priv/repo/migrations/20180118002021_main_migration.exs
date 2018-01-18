defmodule Lsnm.Repo.Migrations.MainMigration do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :password, :string
      add :password_hash, :string
      add :stats, :map
      timestamps()
    end

    create table(:specials) do

      add :place_id, :string
      add :days_of_week, {:array, :string}, default: []
      add :info, :text
      add :reoccuring, :boolean

      timestamps()
    end

  end

end
