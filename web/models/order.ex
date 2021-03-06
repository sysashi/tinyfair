defmodule TinyFair.Order do
  use TinyFair.Web, :model

  @avaialable_statuses ~w(new accepted declined fulfilled)

  schema "orders" do
    field :amount, :integer, default: 1
    field :status, :string, default: "new"
    field :expiry, :utc_datetime
    belongs_to :issuer, User, foreign_key: :user_id
    belongs_to :price, Price
    embeds_many :chosen_services, TinyFair.Embeddeds.Service
    many_to_many :products, Product, join_through: "products_orders"
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:amount, :expiry, :status])
    |> cast_embed(:chosen_services, with: &TinyFair.Embeddeds.Service.order_changeset/2)
    |> validate_required([:amount, :status])
    |> validate_inclusion(:status, @avaialable_statuses)
    |> validate_inclusion(:amount, 1..250) # Maximum allowed amount in one purchase
    |> assoc_constraint(:issuer)
  end

  # O(n^2)?
  def create(changeset, available_servies) when is_list(available_servies) do
    as = Enum.reduce(available_servies, %{}, fn s, acc ->
      Map.put(acc, s.id, s |> Map.from_struct)
    end)
    update_change(changeset, :chosen_services, fn services ->
      IO.inspect services
      Enum.filter(services, & &1.changes.chosen?)
      |> IO.inspect
      |> Enum.map(fn s -> change(s, Map.get(as, s.changes.id, %{})) end)
    end)
  end

  def with_issuer(query) do
    preload(query, :issuer)
  end

  def with_price(query) do
    preload(query, :price)
  end

  def with_products(query) do
    preload(query, :products)
  end

  defp order_by_status(query, statuses) when is_list(statuses) do
    order_by_status(query, Enum.join(", "))
  end

  defp order_by_status(query, statuses) do
    order_by(query, fragment("position(status::varchar in ?)", ^statuses))
  end
end
