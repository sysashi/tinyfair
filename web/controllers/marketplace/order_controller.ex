defmodule TinyFair.Marketplace.OrderController do
  use TinyFair.Web, :controller

  plug Order.Authorization.Plug
  plug :load_product

  def new(conn, %{"id" => product_id}, current_user, product) do
    available_servies = product.current_price.payable_services
    changeset = Order.changeset(%Order{chosen_services: available_servies})
    render(conn, "new.html", changeset: changeset, product: conn.assigns.product)
  end

  def create(conn, %{"id" => product_id, "order" => order_params}, current_user, product) do
    order_changeset = new_order(current_user, product, order_params)
    case Repo.insert(order_changeset) do
      {:ok, order} ->
        conn
        |> render("success.html", product: product, order: order)
      {:error, order_changeset} ->
        conn
        |> put_flash(:error, "Something went wrong with your order.")
        |> render("new.html", changeset: order_changeset, product: product)
    end
  end

  def load_product(conn, _opts) do
    product = Product.available
    |> Product.with_owner
    |> Product.with_orders
    |> Product.with_prices
    |> Repo.get!(conn.params["id"])
    |> add_current_price()

    if product.owner.id == conn.assigns.current_user.id do
      conn
      |> text("GO AWAY, Product owners cannot place orders on their own stuff")
    else
      conn
      |> assign(:product, product)
    end
  end

  def add_current_price(product) do
     Map.put(product, :current_price, product.prices |> List.first)
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user, conn.assigns.product])
  end
end
