defmodule Lsnm.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lsnm.Users.User

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :stats, :map, default: %{}

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :stats])
  end

  def register_user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> unique_constraint(:email)
    |> password_changeset(attrs)
    |> put_pass_hash
  end

  defp password_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_length(:password, min: 8)
    |> validate_format(:password, ~r/[a-z]/)
    |> validate_format(:password, ~r/[A-Z]/)
    |> validate_format(:password, ~r/[0-9]/)
    |> validate_format(:password, ~r/[!@#$%^&+=]/)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end



end
