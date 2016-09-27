defmodule TinyFair.AccountController do
  use TinyFair.Web, :controller
  alias TinyFair.Account

  plug :put_child_layout, {TinyFair.LayoutView, "account.html"}

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
