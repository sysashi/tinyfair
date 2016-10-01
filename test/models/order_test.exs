defmodule TinyFair.OrderTest do
  use TinyFair.ModelCase

  alias TinyFair.Order

  @valid_attrs %{expiry: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, quantity: 42, status: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Order.changeset(%Order{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Order.changeset(%Order{}, @invalid_attrs)
    refute changeset.valid?
  end
end
