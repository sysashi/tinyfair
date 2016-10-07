defmodule TinyFair.MarketplaceView do
  use TinyFair.Web, :view

  def format_price(%{prices: []}) do
    "This product does not specify it's price"
  end

  def format_price(%{prices: [current_price | _history]}) do
    price = "#{current_price.price}"
    currency = current_price.currency |> format_currency
    unit = current_price.unit |> format_unit
    [price, currency, "/", unit]
  end

  def format_currency("THB"), do: "฿"
  def format_currency(currency), do: currency

  def format_unit("package"), do: "pkg."
  def format_unit(unit), do: unit
end
