defmodule TinyFair.AccountController do
  use TinyFair.Web, :controller

  alias TinyFair.Account

  def show(conn, _params) do
    render(conn, "show.html", account: nil)
  end

#  def index(conn, _params) do
#    accounts = Repo.all(Account)
#    render(conn, "index.html", accounts: accounts)
#  end
#
#  def new(conn, _params) do
#    changeset = Account.changeset(%Account{})
#    render(conn, "new.html", changeset: changeset)
#  end
#
#
#  def show(conn, %{"id" => id}) do
#    account = Repo.get!(Account, id)
#    render(conn, "show.html", account: account)
#  end
#
#  def edit(conn, %{"id" => id}) do
#    account = Repo.get!(Account, id)
#    changeset = Account.changeset(account)
#    render(conn, "edit.html", account: account, changeset: changeset)
#  end
#
#  def update(conn, %{"id" => id, "account" => account_params}) do
#    account = Repo.get!(Account, id)
#    changeset = Account.changeset(account, account_params)
#
#    case Repo.update(changeset) do
#      {:ok, account} ->
#        conn
#        |> put_flash(:info, "Account updated successfully.")
#        |> redirect(to: account_path(conn, :show, account))
#      {:error, changeset} ->
#        render(conn, "edit.html", account: account, changeset: changeset)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    account = Repo.get!(Account, id)
#
#    # Here we use delete! (with a bang) because we expect
#    # it to always work (and if it does not, it will raise).
#    Repo.delete!(account)
#
#    conn
#    |> put_flash(:info, "Account deleted successfully.")
#    |> redirect(to: account_path(conn, :index))
#  end
end
