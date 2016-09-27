defmodule TinyFair.LayoutView do
  use TinyFair.Web, :view

  # TODO: mark parent path too
  def active_path_link(helper_fun, conn, opts, do: contents) do
    current_route = existing_route?(conn_controller_action(conn), registered_routes())
    to = helper_fun.(conn)
    opts = if current_route.path == to do
      Keyword.merge(opts, [class: "is-active"], fn :class, v1, v2 -> "#{v1} #{v2}" end)
    else
      opts
    end |> Keyword.merge(to: to)
    link(contents, opts)
  end

  defp existing_route?({controller, action}, routes) when is_list(routes) do
    Enum.find(routes, fn route ->
      route.plug == controller && route.opts == action end)
  end

  defp conn_controller_action(conn) do
    action = conn.private.phoenix_action
    controller = conn.private.phoenix_controller
    {controller, action}
  end

  defp registered_routes, do: TinyFair.Router.__routes__

  def show_alerts(conn, key) when is_atom(key), do: show_alerts(conn, [key])

  def show_alerts(conn, keys) when is_list(keys) do
    fun = &show_flash_alert(conn, &1)
    keys
    |> Enum.map(fn key -> fun.(key) end)
    |> Enum.reject(& is_nil(&1))
  end

  def show_flash_alert(conn, key) do
    if message = get_flash(conn, key) do
      ~e"""
      <p class="alert alert-<%= map_flash_key(key) %>" role="alert"><%= message %></p>
      """
    end
  end

  defp map_flash_key(:error), do: :danger
  defp map_flash_key(key), do: key
end
