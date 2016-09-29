defmodule TinyFair.ProductController do
  use TinyFair.Web, :controller

  plug :put_child_layout, {TinyFair.LayoutView, "account.html"}

  alias TinyFair.Product

  def index(conn, _params, current_user) do
    products = (current_user |> Repo.preload(:products)).products
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

  def edit(conn, %{"id" => id}, current_user) do
    product = Product.by_id(id) |> Product.with_owner |> Repo.one!
    case Product.Authorization.authorize(product, current_user, :update) do
      {:ok, product} ->
        changeset = Product.update_changeset(product)
        render(conn, "edit.html", changeset: changeset)
      any ->
        # FIXME
        IO.inspect any
        TinyFair.AuthHelpers.to_devnull(conn)
    end
  end

  def update(conn, %{"id" => id, "product" => product_params}, current_user) do
    product = Product.by_id(id) |> Product.with_owner |> Repo.one!
    case Product.Authorization.authorize(product, current_user, :update) do
      {:ok, product} ->
        changeset = Product.update_changeset(product, product_params)
        case Repo.update(changeset) do
          {:ok, product} ->
            conn
            |> put_flash(:info, "Product was updated")
            |> render("edit.html", changeset: changeset)
          {:error, changeset} ->
            conn
            |> render("edit.html", changeset: changeset)
        end
      any ->
        # FIXME
        IO.inspect any
        TinyFair.AuthHelpers.to_devnull(conn)
    end
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end
end
