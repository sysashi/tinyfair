defmodule TinyFair.Marketplace.OrderController do
  use TinyFair.Web, :controller

  plug Order.Authorization.Plug
  plug :load_product

  def new(conn, %{"id" => product_id}, current_user, product) do
    available_servies = product.current_price.payable_services
    changeset = Order.changeset(%Order{chosen_services: available_servies})
    render(conn, "new.html", changeset: changeset, product: product)
  end

  def create(conn, %{"order" => order_params}, current_user, product) do
    changeset = new_order(current_user, product, order_params)
    case Repo.insert(changeset) do
      {:ok, order} ->
        conn
        |> put_session(:order_id, order.id)
        |> redirect(to: product_order_path(conn, :success, product))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong with your order.")
        |> render("new.html", changeset: changeset, product: product)
    end
  end

  def success(conn, _params, _current_user, product) do
    if id = get_session(conn, :order_id) do
      order = Repo.get!(Order, id)
      conn
      |> delete_session(:order_id)
      |> render("success.html", product: product, order: order)
    else
      conn
      |> redirect(to: product_order_path(conn, :new, product))
    end
  end

  def load_product(conn, _opts) do
    product = Product.available
    |> Product.with_owner
    |> Product.with_orders
    |> Product.with_prices
    |> Repo.get!(conn.params["id"]) # TODO FIXME
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
