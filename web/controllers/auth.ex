defmodule TinyFair.AuthHelper do
  alias TinyFair.{Repo, User}
  def auth_user?(username, password) do
    user = Repo.get_by(User, username: username)
    {password_check(user, password), user}
  end

  defp password_check(nil, _password), do: Comeonin.Bcrypt.dummy_checkpw
  defp password_check(user, password), do: Comeonin.Bcrypt.checkpw(password, user.password_hash)
end
