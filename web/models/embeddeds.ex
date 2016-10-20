defmodule TinyFair.Embeddeds do
  defmodule Service do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field :service_name
      field :price, :integer
      field :currency
      field :unit

      field :chosen?, :boolean, virtual: true
    end

    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:service_name, :chosen?, :id])
      |> validate_required([:service_name])
      |> validate_length(:service_name, max: 70)
      |> TinyFair.Price.changeset(params)
    end

    def order_changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:id, :chosen?])
      |> validate_required([:id, :chosen?])
    end
  end
end
