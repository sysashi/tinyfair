defmodule TinyFair.AccountController do
  use TinyFair.Web, :controller
  alias TinyFair.Account

  plug :put_child_layout, {TinyFair.LayoutView, "account.html"}

  def show(conn, _params, current_user) do
    render(conn, "show.html", user: current_user)
  end

  def orders(conn, _params, current_user) do
    user = current_user |> Repo.preload(orders: :products)
    render(conn, "orders.html", orders: user.orders)
  end

  def contacts(conn, _params, current_user) do
    changeset = User.update_contacts(current_user)
    conn
    |> render("edit.html", changeset: changeset)
  end

  def update(conn, %{"contacts" => _c} = params, current_user) do
    update_contacts(conn, params, current_user)
  end
  def update(conn, %{"settings" => _s} = params, current_user) do
    update_contacts(conn, params, current_user)
  end

  def update_settings(conn, %{"user" => contacts_params}, current_user) do
    case update_user(current_user, :settings, contacts_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "You have updated your settings")
        |> redirect(to: account_path(conn, :settings))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error updating settings")
        |> render("edit.html", changeset: changeset)
    end
  end

  def update_contacts(conn, %{"user" => contacts_params}, current_user) do
    case update_user(current_user, :contacts, contacts_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "You have updated your contacts")
        |> redirect(to: account_path(conn, :contacts))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error updating contacts")
        |> render("edit.html", changeset: changeset)
    end
  end

  # TODO
  def update_user(user, :contacts, params) do
    user
    |> User.update_contacts(params)
    |> Repo.update
  end

  def update_user(user, :settings, params) do
    user
    |> User.update_settings(params)
    |> Repo.update
  end

  def update_user(user, params) do
    user
    |> User.changeset(params)
    |> Repo.update
  end


  # Overrides phoenix's action/2
  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end
end
