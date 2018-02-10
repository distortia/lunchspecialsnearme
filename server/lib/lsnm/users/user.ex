defmodule Lsnm.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lsnm.Users.User

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :stats, :map, default: %{specials_added: 0}
    field :temp_id, :string, default: nil
    has_many :specials, Lsnm.Specials.Special

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :stats])
  end

  def update_user_changeset(%User{}  = user, attrs) do
    case attrs["password"] do
      nil -> 
        user
        |> cast(attrs, [:email])
        |> email_changeset(attrs)
      _ ->
        user
        |> cast(attrs, [:email])
        |> password_changeset(attrs)
        |> put_pass_hash()
        |> email_changeset(attrs)
    end
  end

  def register_user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> password_changeset(attrs)
    |> put_pass_hash
  end

  def reset_user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:temp_id])
    |> unique_constraint(:temp_id)
  end

  def update_reset_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:temp_id])
    |> password_changeset(attrs)
    |> put_pass_hash()
    |> remove_temp_id()
  end

  defp password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_length(:password, min: 8)
  #   |> validate_format(:password, ~r/[a-z]/)
  #   |> validate_format(:password, ~r/[A-Z]/)
  #   |> validate_format(:password, ~r/[0-9]/)
  #   |> validate_format(:password, ~r/[!@#$%^&+=]/)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  defp email_changeset(user, attrs) do
      user
      |> cast(attrs, ~w(email), [])
      |> validate_length(:email, min: 1)
      |> validate_format(:email, ~r/@/) # Checks for @ sign in email
      |> update_change(:email, &String.downcase/1) # Normalize all emails
      |> unique_constraint(:email)
  end

  defp remove_temp_id(changeset) do
    Ecto.Changeset.change(changeset, temp_id: nil)
  end
end
