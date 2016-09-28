defmodule TinyFair.Utils do
  def list_of_integers?(list) when is_list(list), do: Enum.all?(list, &is_integer/1)
end
