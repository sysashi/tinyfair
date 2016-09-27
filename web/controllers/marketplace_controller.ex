defmodule TinyFair.MarketplaceController do
  use TinyFair.Web, :controller

  def show(conn, _params) do
    IO.inspect conn
    render(conn, "show.html")
  end
end
