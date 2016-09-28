defmodule TinyFair.ProductView do
  use TinyFair.Web, :view

  def humanize_status("instock"), do: "In Stock"
  def humanize_status("outstock"), do: "Out of Stock"
  def humanize_status(status), do: status
end
