defmodule Lsnm.SpecialTest do
  use Lsnm.ModelCase

  alias Lsnm.Special

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Special.changeset(%Special{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Special.changeset(%Special{}, @invalid_attrs)
    refute changeset.valid?
  end
end
