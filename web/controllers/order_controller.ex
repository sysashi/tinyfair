defmodule TinyFair.OrderController do
  use TinyFair.Web, :controller
  plug :put_child_layout, {TinyFair.LayoutView, "account.html"}

  def index(conn, _params, current_user) do
    user = current_user |> Repo.preload(orders: :products)
    render(conn, "index.html", orders: user.orders)
  end

  def show(conn, %{"id" => id}, _current_user) do
    order = Repo.get!(Order, id)
    render(conn, "show.html", order: order)
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end
end
