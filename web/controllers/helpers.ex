defmodule TinyFair.ControllerHelpers do
  import Plug.Conn, only: [assign: 3]

  def put_child_layout(conn, layout) when is_tuple(layout) or
    is_binary(layout) or is_atom(layout) do
    assign(conn, :child_layout, layout)
  end
end
