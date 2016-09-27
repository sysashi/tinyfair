defmodule TinyFair.Product do
  use TinyFair.Web, :model

  @avaialable_statuses ~w(instock outstock hidden stash)

  schema "products" do
    field :name, :string
    field :quantity, :integer, default: 0
    field :image_url, :string
    field :desc, :string
    field :status, :string, default: "stash"
    belongs_to :owner, TinyFair.User, foregin_key: :user_id

    field :deleted_at, Ecto.DateTime
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :quantity, :image_url, :desc, :status])
    |> validate_required([:name, :quantity, :image_url, :desc, :status])
  end
end
