defmodule TinyFair.AuthPlugs do
  import Plug.Conn
  import Phoenix.Controller, only: [put_view: 2, put_flash: 3, redirect: 2, render: 2]
  import TinyFair.InviteHelper

  defmodule UserOnly do
    import TinyFair.AuthHelpers
    def init(opts \\ []), do: opts

    def call(conn, opts) do
      if user_id = get_session(conn, :user_id) do
        case user_status(user_id) do
          {:ok, user} ->
            conn
            |> assign(:current_user, user)
          {:banned, _user} ->
            conn
            |> put_flash(:error, "Your account is banned: reason")
            |> redirect(to: "/")
            |> halt()
          {:not_existing, _user_id} ->
            to_devnull(conn)
        end
      else
        to_devnull(conn)
      end
    end

    # FIXME
    defp user_status(user_id) do
      if user = TinyFair.Repo.get(TinyFair.User, user_id) do
        case user do
          %{status: "banned"} = user ->
            {:banned, user}
          user -> {:ok, user}
        end
      else
        {:not_existing, user_id}
      end
    end
  end

  defmodule InviteOnly do
    # TODO: handle current user / user session
    def init(opts \\ []), do: opts

    def call(conn, opts) do
      if token = get_session(conn, :invite_token) do
        case registrable(token) do
          {true, invite} ->
            conn
            |> assign(:invite, invite)
          {false, _invite} ->
            conn
            |> put_flash(:error, "Oops your invite is no longer valid")
            |> delete_session(:invite_token)
            |> invalid_token
        end
      else
        invite_rules_path = Keyword.get(opts, :redirect_path, "/invite-rules")
        conn
        |> invalid_token(invite_rules_path)
      end
    end

    defp invalid_token(conn, redirect_path \\ "/") do
      conn
      |> redirect(to: redirect_path)
      |> halt()
    end
  end
end
