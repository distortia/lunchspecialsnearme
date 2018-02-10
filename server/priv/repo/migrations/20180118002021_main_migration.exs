defmodule Lsnm.Repo.Migrations.MainMigration do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :password, :string
      add :password_hash, :string
      add :stats, :map
      add :temp_id, :string
      
      timestamps()
    end

    create table(:specials) do

      add :place_id, :string
      add :day_of_week, :string 
      add :info, :text
      add :reoccuring, :boolean
      add :name, :string
      add :user_id, references(:users)

      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])

  end

end
