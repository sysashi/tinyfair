defmodule TinyFair.Marketplace.OrderView do
  use TinyFair.Web, :view
  import TinyFair.MarketplaceView, only: [
    format_currency: 1,
    format_price: 1,
    format_unit: 1
  ]

  def format_service(service) do
    "+ #{service.service_name} #{service.price} #{service.currency |> format_currency}"
  end

  def price_total(order, price) do
    order_total = order.amount * price.price
    services_total = order.chosen_services
    |> Enum.reduce(0, fn %{price: price}, acc ->
      acc + price
    end)
    order_total + services_total
  end

  def format_order_total(order, price) do
    ~e"""
    <%= order.amount %> <%= price.unit %>(s) ✕ <%= price.price %> <%= price.currency |> format_currency %>
    """
  end
end
