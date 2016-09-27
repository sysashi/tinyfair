defmodule TinyFair.Account.UserController do
  use TinyFair.Web, :controller

  plug :put_child_layout, {TinyFair.LayoutView, "account.html"}

  def contacts(conn, _params, current_user) do
    changeset = User.update_contacts(current_user)
    conn
    |> render("edit.html", changeset: changeset)
  end

  def update_contacts(conn, %{"user" => contacts_params}, current_user) do
    changeset = User.update_contacts(current_user, contacts_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "You have updated your contacts")
        |> render("edit.html", changeset: changeset)
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error updating contacts")
        |> render("edit.html", changeset: changeset)
    end
  end

  # Overrides phoenix's action/2
  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end
end
