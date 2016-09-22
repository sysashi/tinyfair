defmodule TinyFair.RegistrationController do
  use TinyFair.Web, :controller

  alias TinyFair.User

  def new(conn, _params) do
    changeset = User.registration_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
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
end
