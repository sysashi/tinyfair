defmodule TinyFair.Session do
  use TinyFair.Web, :model

  embedded_schema do
    field :username
    field :password
  end

  @required_fields [:username, :password]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end
