defmodule TinyFair.PageController do
  use TinyFair.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
