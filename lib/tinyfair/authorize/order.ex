defmodule TinyFair.Order.Authorization do
  use Authorize
  alias TinyFair.User

  rule :global, "only users with permissions to sell and buy can interact with orders", struct_or_cs, actor do
    if User.Permissions.to_buy_products?(actor) or User.Permissions.to_sell_products?(actor) do
      :undecided
    else
      :unauthorized
    end
  end

  rule [:index], "users can list their orders", struct_or_cs, actor do
    if is_nil(struct_or_cs) do
      :ok
    else
      # TODO
      :undecided
    end
  end

  rule [:new, :create, :success], "only users with permission to buy can create orders", struct_or_cs, actor do
    if User.Permissions.to_buy_products?(actor) do
      :ok
    else
      :unauthorized
    end
  end

  rule [:edit, :update], "only users with permission to sell can change orders", struct_or_cs, actor do
    if User.Permissions.to_sell_products?(actor) do
      :undecided
    else
      :unauthorized
    end
  end

  rule [:edit, :update, :show], "users can only interact with orders they issued", struct_or_cs, actor do
    order = get_struct(struct_or_cs)
    if order.issuer.id == actor.id do
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
      order = if action_name(conn) in [:edit, :update, :show] do
        key = opts[:param] || "id"
        id = Map.get(conn.params, key)
        Order |> Order.with_issuer |> Repo.get!(id)
      end
      case Order.Authorization.authorize(order, current_user, action_name(conn)) do
        {:ok, nil} ->
          conn
        {:ok, order} ->
          assign(conn, :order, order)
        {:unauthorized, order, rule} ->
          # TODO: LOG access
          # return back to referer or to dev null?
          IO.warn("Unauthorized access to order: #{inspect order}\
          from user: #{inspect current_user.username}\
          rule: #{rule}")
          conn
          |> TinyFair.AuthHelpers.to_devnull
      end
    end
  end
end
