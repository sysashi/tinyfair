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
    |> validate_format(:name, ~r/^[a-zA-Z0-9_\-\.!~\*'\(\)\ ]+$/)
    |> validate_length(:name, min: 4, max: 20)
    |> validate_length(:desc, max: 140)
    |> assoc_constraint(:owner)
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
  end

  def create_changeset(struct, params \\ %{}) do
    params = maybe_put_image(params)
    struct
    |> changeset(params)
    |> validate_required([:name, :desc])
    |> cast_attachments(params, [:image_url])
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
