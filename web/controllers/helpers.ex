defmodule TinyFair.ControllerHelpers do
  import Plug.Conn, only: [assign: 3]
  import Ecto, only: [build_assoc: 2, assoc: 2]
  import Ecto.Changeset, only: [put_assoc: 3]

  alias TinyFair.Order

  def new_price_version() do
    
  end

  def new_order(user, product, order_params) do
    order_changeset = build_assoc(user, :orders)
    |> Order.changeset(order_params)
    |> Order.create(product.current_price.payable_services)
    |> put_assoc(:price, product.current_price)
    |> put_assoc(:products, [product])
  end

  def put_child_layout(conn, layout) when is_tuple(layout) or
    is_binary(layout) or is_atom(layout) do
    assign(conn, :child_layout, layout)
  end
end
