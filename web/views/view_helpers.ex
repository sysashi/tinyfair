defmodule TinyFair.ViewHelpers do
  @moduledoc false

  def dotify(string, max_length \\ 140) when
      is_integer(max_length) and max_length > 0 do
    str = String.slice(string, 0, max_length)
    len = String.length(str)
    if max_length - len <= 3 do
       String.pad_trailing(str, max_length + 3, ".")
    else
      string
    end
  end

  @priv_prefix "/priv/static"
  def image_url(string) when is_binary(string), do: string
  def image_url(%struct_mod{} = struct, field) when is_atom(field) do
    mod = "#{struct_mod}Image"
    file_params = Map.get(struct, field, nil)
    try do
      :"#{mod}".url({file_params, struct})
      |> remove_prefix()
    rescue
      # TODO: Add default image?
      any -> raise "Arc module (#{mod}) is not implemented: #{inspect any}"
    end
  end

  def humanize_status("instock"), do: "In Stock"
  def humanize_status("outstock"), do: "Out of Stock"
  def humanize_status("stash"), do: "Stash"
  def humanize_status("hidden"), do: "Hidden"
  def humanize_status(status), do: status

  defp remove_prefix(string, prefix \\ @priv_prefix) do
    if prefix do
      String.trim_leading(string, prefix)
    else
      string
    end
  end
end
