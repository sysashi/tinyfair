defmodule TinyFair.AccountController do
  use TinyFair.Web, :controller
  alias TinyFair.Account

  plug :put_child_layout, {TinyFair.LayoutView, "account.html"}

  def show(conn, _params) do
    current_user = conn.assigns.current_user
    render(conn, "show.html", user: current_user)
  end
end
