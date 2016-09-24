defmodule TinyFair.LayoutView do
  use TinyFair.Web, :view

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
