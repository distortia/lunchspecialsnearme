defmodule LsnmWeb.Guardian do
  use Guardian, otp_app: :lsnm
  alias Lsnm.Repo
  alias Lsnm.Users.User
  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(claims) do
    user = Repo.get(User, claims["sub"])
    {:ok, user}
  end
end