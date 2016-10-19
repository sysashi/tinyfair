defmodule TinyFair.Product.OrderController do
  use TinyFair.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
