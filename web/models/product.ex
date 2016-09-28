defmodule TinyFair.Product do
  use TinyFair.Web, :model

  @avaialable_statuses ~w(instock outstock hidden stash)

  schema "products" do
    field :name, :string
    field :quantity, :integer, default: 0
    field :image_url, :string
    field :desc, :string
    field :status, :string, default: "stash"
    belongs_to :owner, TinyFair.User, foreign_key: :user_id

    field :deleted_at, Ecto.DateTime
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :quantity, :image_url, :desc, :status, :user_id])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
    |> assoc_constraint(:owner)
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> validate_required([:name, :desc])
    |> validate_format(:name, ~r/^[a-z0-9_\-\.!~\*'\(\)]+$/)
  end

  # status should be in [:instock, :outstock]
  # user(owner) should not be banned
  # it should not be deleted
  def listed do
    from(p in all(), where: p.status in ["instock", "outstock"])
    |> owner_is_active
  end

  def all do
    from(p in Product, where: is_nil(p.deleted_at))
  end

  defp owner_is_active(query) do
    from(p in query, join: o in assoc(p, :owner),
      where: o.status == "active",
      preload: [owner: o])
  end
end
