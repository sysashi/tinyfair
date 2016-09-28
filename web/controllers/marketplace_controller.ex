defmodule TinyFair.MarketplaceController do
  use TinyFair.Web, :controller

  def index(conn, _params) do
    products = Product.listed |> Repo.all
    render(conn, "index.html", products: products)
  end
end
