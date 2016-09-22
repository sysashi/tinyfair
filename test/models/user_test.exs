defmodule TinyFair.UserTest do
  use TinyFair.ModelCase

  alias TinyFair.User

  @valid_attrs %{password: "somecontent", username: "somecontent"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "registration changeset with valid attributes" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end
end
