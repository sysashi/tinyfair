defmodule TinyFair.User.Permissions do
  use __MODULE__.Helpers

  # User can
  @permissions [
    :can_sell_products,
    :can_buy_products,
    :can_use_chat,
  ]

  @seller [:can_sell_products]

  def seller, do: @seller
  def regular_user, do: all -- seller
end
