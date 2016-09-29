defmodule TinyFair.Repo do
  use Ecto.Repo, otp_app: :tinyfair
  import Ecto.Query

  def count(%mod{} = struct, assoc) when is_atom(assoc) do
    from(c in mod, where: c.id == ^struct.id,
      join: o in assoc(c, ^assoc),
      select: count(o.id),
      group_by: c.id)
  end
end
