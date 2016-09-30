defmodule TinyFair.ProductController do
  use TinyFair.Web, :controller

  plug :put_child_layout, {TinyFair.LayoutView, "account.html"}
  plug Product.Authorization.Plug

  alias TinyFair.Product

  def index(conn, _params, current_user) do
    render(conn, "index.html", products: current_user.products)
  end

  def stash(conn, _params, current_user) do
    products = current_user.products |> Enum.reject(& &1.status != "stash")
    render(conn, "index.html", products: products)
  end

  def new(conn, _params, _) do
    changeset = Product.changeset(%Product{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product" => product_params}, current_user) do
    product = Ecto.build_assoc(current_user, :products)
    changeset = Product.create_changeset(product, product_params)
    case Repo.insert(changeset) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product was created")
        |> render("new.html", changeset: changeset)
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, _params, current_user) do
    changeset = Product.update_changeset(conn.assigns.product)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"product" => product_params}, current_user) do
    changeset = Product.update_changeset(conn.assigns.product, product_params)
    case Repo.update(changeset) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product was updated")
        |> render("edit.html", changeset: changeset)
      {:error, changeset} ->
        conn
        |> render("edit.html", changeset: changeset)
    end
  end

  def action(conn, _) do
    user = conn.assigns.current_user |> Repo.preload(:products)
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, user])
  end
end
