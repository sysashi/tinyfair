defmodule TinyFair.Product.Authorization do
  use Authorize
  alias TinyFair.User

  rule :global, "only sellers can interact with products", struct_or_cs, actor do
    if User.Permissions.to_sell_products?(actor) do
      :undecided
    else
      :unauthorized
    end
  end

  rule [:new, :create], "users can create new products", struct_or_cs, actor do
    :ok
  end

  rule [:index, :stash, :purchase_orders], "users can list their products and it's orders",
    struct_or_cs, actor do
    :ok
  end

  rule [:edit, :update], "users can only change products they own", struct_or_cs, actor do
    product = get_struct(struct_or_cs)
    if product.owner.id == actor.id do
      :ok
    else
      :unauthorized
    end
  end

  defmodule Plug do
    import Phoenix.Controller, only: [action_name: 1]
    import Elixir.Plug.Conn, only: [assign: 3]
    use TinyFair.Web, :aliases

    def init(opts), do: opts

    def call(conn, opts) do
      current_user = conn.assigns[:current_user]
      product = if action_name(conn) in [:edit, :update] do
        key = opts[:param] || "id"
        id = Map.get(conn.params, key)
        Product.available |> Product.with_owner |> Product.with_prices |> Repo.get!(id)
      end
      case Product.Authorization.authorize(product, current_user, action_name(conn)) do
        {:ok, nil} ->
          conn
        {:ok, product} ->
          assign(conn, :product, product)
        {:unauthorized, product, rule} ->
          # TODO: LOG access
          # return back to referer or to dev null?
          IO.warn("Unauthorized access to product: #{inspect product}\
          from user: #{inspect current_user.username}\
          rule: #{rule}")
          conn
          |> TinyFair.AuthHelpers.to_devnull
      end
    end
  end
end
