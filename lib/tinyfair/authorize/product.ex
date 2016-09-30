defmodule TinyFair.Product.Authorization do
  use Authorize

  @crud [:create, :read, :update, :delete]

  rule @crud -- [:create],
    "users can only interact with their own products", struct_or_cs, actor do
    product = get_struct(struct_or_cs)
    if product.owner.id == actor.id do
      :ok
    else
      :unauthorized
    end
  end
end
