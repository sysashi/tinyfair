defmodule TinyFair.Marketplace.OrderView do
  use TinyFair.Web, :view
  import TinyFair.MarketplaceView, only: [
    format_currency: 1,
    format_price: 1,
    format_unit: 1
  ]
end
