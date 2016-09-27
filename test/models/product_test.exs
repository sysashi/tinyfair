defmodule TinyFair.ProductTest do
  use TinyFair.ModelCase

  alias TinyFair.Product

  @valid_attrs %{desc: "some content", image_url: "some content", name: "some content", quantity: 42, status: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
