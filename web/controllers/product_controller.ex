defmodule TinyFair.ProductController do
  use TinyFair.Web, :controller

  alias TinyFair.Product

  def index(conn, _params) do
    products = Repo.all(Product)
    render(conn, "index.html", products: products)
  end
end
