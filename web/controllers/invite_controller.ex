defmodule TinyFair.InviteController do
  use TinyFair.Web, :controller
  import TinyFair.InviteHelper

  def activation_page(conn, params) do
    changeset = Invite.changeset(%Invite{}, params)
    render conn, "activate.html", changeset: changeset
  end

  def invite_rules(conn, _params) do
    conn
  end

  def activate(conn, %{"invite" => %{"token" => token}} = params) do
    changeset = Invite.changeset(%Invite{}, params)
    if registrable?(token) do
      conn
      |> put_session(:invite_token, token)
      |> redirect(to: registration_path(conn, :new))
    else
      conn
      |> put_flash(:error, "Oops something is wrong with this invite")
      |> render("activate.html", changeset: changeset)
    end
  end
end
