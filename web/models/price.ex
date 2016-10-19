defmodule TinyFair.Price do
  use TinyFair.Web, :model

  @avaialable_currencies ~w(USD THB)
  @avaialable_units ~w(mg g gm kg ml l package)
  @maximum_price 10_000 # units
  @maximum_extra_fee 1000 # units

  schema "prices" do
    field :price, :integer, default: 0
    field :currency
    field :unit
    embeds_many :payable_services, TinyFair.Embeddeds.Service

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:price, :currency, :unit])
    |> validate_required([:price, :currency, :unit])
    |> validate_number(:price, greater_than_or_equal_to: 100, less_than: @maximum_price)
    |> validate_inclusion(:currency, @avaialable_currencies)
    |> validate_inclusion(:unit, @avaialable_units)
    |> update_change(:currency, &String.upcase/1)
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast_embed(:payable_services)
  end
end
