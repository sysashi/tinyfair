defmodule TinyFair.AuthHelpers do
  import Plug.Conn, only: [halt: 1, put_status: 2]
  import Phoenix.Controller, only: [put_view: 2, render: 2]
  alias TinyFair.{Repo, User}

  def to_devnull(conn) do
    conn
    |> put_view(TinyFair.ErrorView)
    |> put_status(:not_found)
    |> render("404.html")
    |> halt()
  end

  def auth_user?(username, password) do
    user = Repo.get_by(User, username: username)
    {password_check(user, password), user}
  end

  defp password_check(nil, _password), do: Comeonin.Bcrypt.dummy_checkpw
  defp password_check(user, password), do: Comeonin.Bcrypt.checkpw(password, user.password_hash)
end
