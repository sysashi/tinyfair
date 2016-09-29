defmodule TinyFair.Repo do
  use Ecto.Repo, otp_app: :tinyfair
  import Ecto.Query

  def count(%mod{} = struct, assoc, count_by \\ :id) when is_atom(assoc) do
    Ecto.assoc(struct, assoc)
    |> TinyFair.Repo.aggregate(:count, count_by)
  end
end
