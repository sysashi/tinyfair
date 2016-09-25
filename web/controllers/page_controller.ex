defmodule TinyFair.PageController do
  use TinyFair.Web, :controller

  def index(conn, _params) do
    conn
    |> put_layout("clean.html")
    |> render("index.html")
  end
end
