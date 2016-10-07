defmodule TinyFair.Product do
  use TinyFair.Web, :model
  use Arc.Ecto.Schema

  @avaialable_statuses ~w(instock outstock hidden stash)

  schema "products" do
    field :name, :string
    field :quantity, :integer, default: 0
    field :image_url, TinyFair.ProductImage.Type
    field :desc, :string
    field :status, :string, default: "stash"

    many_to_many :prices, Price, join_through: "products_prices"
    belongs_to :owner, User, foreign_key: :user_id
    many_to_many :orders, Order, join_through: "products_orders"

    field :delete?, :boolean, virtual: true
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
    |> validate_format(:name, ~r/^[a-zA-Z0-9_\-\.!~\*'\(\)\ ]+$/)
    |> validate_length(:name, min: 4, max: 20)
    |> validate_length(:desc, max: 140)
    |> validate_inclusion(:status, @avaialable_statuses)
    |> assoc_constraint(:owner)
    |> cast_assoc(:prices, required: true, with: &Price.create_changeset/2)
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
  end

  def create_changeset(struct, params \\ %{}) do
    # FIXME
    params = maybe_put_image(params)
    struct
    |> changeset(params)
    |> validate_required([:name, :desc])
    |> cast_attachments(params, [:image_url])
  end

  def place_order(product, order) do
    product
    |> update_changeset
    |> put_assoc(:orders, product.orders ++ [order])
    |> only_allowed_status("instock")
  end

  def marketplace_entry do
    available
    |> can_be_listed
    |> with_active_owner
    |> preload(:prices)
  end

  def available do
    where(Product, [p], is_nil(p.deleted_at))
  end

  def can_be_purchased(query) do
    where(query, status: "instock")
  end

  def can_be_listed(query)do
    where(query, [p], p.status in ["instock", "outstock"])
  end

  def in_stash(query) do
    where(query, status: "stash")
  end

  def with_prices(query) do
    preload(query, :prices)
  end

  def with_owner(query) do
    preload(query, :owner)
  end

  def with_orders(query) do
    preload(query, :orders)
  end

  def with_active_owner(query) do
    from(p in with_owner(query), join: o in assoc(p, :owner),
      where: o.status == "active")
  end

  def only_allowed_status(changeset, status) do
    current_status = get_field(changeset, :status)
    if current_status == status do
      changeset
    else
      changeset
      |> add_error(:status, "allowed status: #{status}")
      |> delete_change(:orders)
    end
  end

  def maybe_put_image(params) do
    random_string = :os.system_time |> Integer.to_string |> Base.encode16
    case generate_image(params["name"] || random_string) do
      {:ok, image} ->
        Map.put(params, "image_url", %{filename: random_string, binary: image})
      {:error, _} ->
        params
    end
  end

  defp generate_image(nil), do: {:error, :no_seed}
  defp generate_image(name) when is_binary(name) do
    IO.inspect name
    Identicon.render(name) |> Base.decode64
  end
end
