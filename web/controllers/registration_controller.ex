defmodule TinyFair.RegistrationController do
  use TinyFair.Web, :controller

  alias TinyFair.User

  def new(conn, _params) do
    changeset = User.registration_changeset(%User{})
    invite = extract_invite(conn)
    render(conn, "new.html", changeset: changeset, invite: invite)
  end

  def create(conn, %{"user" => registration_params}) do
    changeset = User.registration_changeset(%User{}, registration_params)

    case Repo.insert(changeset) do
      {:ok, _registration} ->
        conn
        |> put_flash(:info, "Registration completed successfully.")
        |> redirect(to: "/")
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp extract_invite(%Plug.Conn{assigns: %{invite: invite}}) do
    invite |> Repo.preload(:inviter)
  end
  defp extract_invite(_conn), do: nil
end
