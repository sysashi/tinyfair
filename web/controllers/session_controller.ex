defmodule TinyFair.SessionController do
  @moduledoc """
  TODO Abstract sessions from html form.
  Allow multiple and differentiate ({app, mobile}, browser, api?)

  Rate limit |
  Throttle   |  - > everything
  """

  use TinyFair.Web, :controller

  import TinyFair.AuthHelper

  alias TinyFair.Session

  plug :scrub_params, "session" when action == :create

  # Show login form
  def new(conn, _params) do
    changeset = Session.changeset(%Session{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    conn
    |> sign_in(Session.changeset(%Session{}, session_params))
  end


  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> redirect(to: "/")
  end

  defp sign_in(conn, %Ecto.Changeset{valid?: true} = changeset) do
    username = Ecto.Changeset.get_field(changeset, :username)
    password = Ecto.Changeset.get_field(changeset, :password)

    case auth_user?(username, password) do
      {true, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: account_path(conn, :show))
      {false, _user} ->
        failed_login(conn)
    end
  end

  defp sign_in(conn, _changeset), do: failed_login(conn)

  defp failed_login(conn) do
    conn
    |> put_flash(:error, "Oops something went wrong! Username or password is incorrect")
    |> redirect(to: session_path(conn, :new))
    |> halt()
  end
end
