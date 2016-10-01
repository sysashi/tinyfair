defmodule TinyFair.Order do
  use TinyFair.Web, :model

  @avaialable_statuses ~w(new accepted declined fulfilled)

  schema "orders" do
    field :amount, :integer, default: 1
    field :status, :string, default: "new"
    field :expiry, :utc_datetime
    belongs_to :issuer, User, foreign_key: :user_id
    embeds_one :extra_fees, Order.ExtraFees
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:amount, :expiry, :status])
    |> validate_required([:amount, :status])
    |> validate_inclusion(:status, @avaialable_statuses)
    |> validate_inclusion(:amount, 1..250)
    |> assoc_constraint(:issuer)
  end

  def with_issuer(query) do
    preload(query, :issuer)
  end

  defmodule ExtraFees do
    use Ecto.Schema

    embedded_schema do
      field :feename
      field :amount
    end
  end
end
