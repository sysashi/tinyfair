defmodule TinyFair.Marketplace.OrderController do
  use TinyFair.Web, :controller

  plug Order.Authorization.Plug
  plug :load_product

  def new(conn, %{"id" => product_id}, current_user) do
    # TODO: Show product card
    changeset = Order.changeset(%Order{})
    render(conn, "new.html", changeset: changeset, product: conn.assigns.product)
  end

  def create(conn, %{"id" => product_id, "order" => order_params}, current_user) do
    order_changeset = Ecto.build_assoc(current_user, :orders) |> Order.changeset(order_params)
    product_changeset = conn.assigns.product |> Product.place_order(order_changeset)
    case Repo.update(product_changeset) do
      {:ok, _product} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: marketplace_path(conn, :index))
      {:error, _changeset} ->
        IO.inspect  order_changeset
        render(conn, "new.html", changeset: order_changeset, produce: conn.assigns.product)
    end
  end

  def load_product(conn, _opts) do
    product = Product.available
    |> Product.with_owner
    |> Product.with_orders
    |> Repo.get!(conn.params["id"])
    if product.owner.id == conn.assigns.current_user.id do
      conn
      |> text("GO AWAY, Product owners cannot place orders on their own stuff")
    else
      conn
      |> assign(:product, product)
    end
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end
end
