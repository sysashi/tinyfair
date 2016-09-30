defmodule TinyFair.RegistrationController do
  use TinyFair.Web, :controller

  alias TinyFair.User

  def new(conn, _params) do
    changeset = User.registration_changeset(%User{})
    render(conn, "new.html", changeset: changeset, invite: extract_invite(conn))
  end

  def create(conn, %{"user" => registration_params}) do
    invite = extract_invite(conn)
    case TinyFair.UserHelpers.new_user(registration_params, invite) do
      {:ok, new_user} ->
        # TODO: Use Ecto.Multi
        activate_invite(invite)
        conn
        |> put_flash(:info, "Registration completed successfully.")
        |> put_session(:user_id, new_user.id)
        |> redirect(to: account_path(conn, :show))
      {:error, changeset} ->
        conn
        # |> put_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render("new.html", changeset: changeset)
    end
  end

  defp extract_invite(%Plug.Conn{assigns: %{invite: invite}}) do
    invite |> Repo.preload(:inviter)
  end
  defp extract_invite(_conn), do: nil

  defp activate_invite(%Invite{} = invite) do
    Invite.changeset(invite, %{activated_at: Ecto.DateTime.utc})
    |> Repo.update!
  end
  defp activate_invite(nil), do: nil
end
