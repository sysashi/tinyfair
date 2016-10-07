defmodule TinyFair.Marketplace.OrderController do
  use TinyFair.Web, :controller

  plug Order.Authorization.Plug
  plug :load_product

  def new(conn, %{"id" => product_id}, current_user) do
    # TODO: Show product card
    product = conn.assigns.product
    available_servies = current_price(product).payable_services
    changeset = Order.changeset(%Order{chosen_services: available_servies})
    render(conn, "new.html", changeset: changeset, product: conn.assigns.product)
  end

  def create(conn, %{"id" => product_id, "order" => order_params}, current_user) do
    # FIXME ASAP BRO
    IO.inspect order_params
    product = conn.assigns.product
    order_changeset = build_assoc(current_user, :orders, %{price_id: current_price(product).id })
    |> Order.changeset(order_params)
    |> Ecto.Changeset.update_change(:chosen_services, fn services ->
      Enum.filter(services, & &1.changes.chosen?)
      |> Enum.map(fn service ->
         Enum.find(current_price(product).payable_services, & &1.id == service.changes.id)
        |> TinyFair.Embeddeds.Service.changeset
        |> Map.put(:action, :insert)
      end)
    end)
    |> IO.inspect
    product_changeset = product |> Product.place_order(order_changeset)
    case Repo.update(product_changeset) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> render("success.html",
                  product: product,
                  order: Ecto.Changeset.apply_changes(order_changeset))
      {:error, product_changeset} ->
        IO.inspect merge_errors(order_changeset, product_changeset)
        changeset = Ecto.Changeset.apply_changes(order_changeset)
        |> Order.changeset
        |> IO.inspect
        conn
        |> put_flash(:error, "Something went wrong with your order.")
        |> render("new.html", changeset: changeset, produce: conn.assigns.product)
    end
  end

  def load_product(conn, _opts) do
    product = Product.available
    |> Product.with_owner
    |> Product.with_orders
    |> Product.with_prices
    |> Repo.get!(conn.params["id"])

    if product.owner.id == conn.assigns.current_user.id do
      conn
      |> text("GO AWAY, Product owners cannot place orders on their own stuff")
    else
      conn
      |> assign(:product, product)
    end
  end

  def current_price(product) do
    product.prices |> List.first
  end

  def merge_errors(cs1, cs2) do
    cs1
    |> Map.put(:errors, cs1.errors ++ cs2.errors)
    |> Map.put(:valid?, cs1.valid? and cs2.valid?)
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end
end
