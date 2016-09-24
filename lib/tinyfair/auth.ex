defmodule TinyFair.Auth do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import TinyFair.InviteHelper

  defmodule InviteOnly do
    def init(opts \\ []), do: opts

    def call(conn, opts) do
      if token = get_session(conn, :invite_token) do
        case registrable(token) do
          {true, invite} ->
            conn
            |> assign(:invite, invite)
          {false, _invite} ->
            conn
            |> put_flash(:error, "Oops your token is invalid")
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
