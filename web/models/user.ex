defmodule TinyFair.User do
  use TinyFair.Web, :model

  @avaialable_statuses ~w(active hidden banned)

  schema "users" do
    field :username
    field :password, :string, virtual: true
    field :password_hash

    field :email
    field :phone
    field :line_id

    field :status, :string, default: "active"
    field :level, :float, default: 0.0

    many_to_many :roles, UserRole, join_through: "users_roles", on_replace: :delete

    has_many :products, Product
    has_many :orders, Order

    # being an inviter
    has_many :invites, Invite

    # being an invitee
    belongs_to :invite, Invite

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
  end

  def update_contacts(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :phone, :line_id])
    |> validate_format(:email, ~r/@/)
  end

  def update_settings(struct, params) do
    struct
    |> cast(params, [])
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> update_change(:username, &String.downcase/1)
    |> validate_length(:username, min: 4, max: 20)
    |> validate_length(:password, min: 6)
    |> validate_format(:username, ~r/^[a-z0-9_\-\.!~\*'\(\)]+$/)
    |> unique_constraint(:username)
    |> cast_assoc(:roles, required: true)
    |> hash_password()
  end

  def with_roles(query) do
    preload(query, roles: :permissions)
  end

  def set_roles(struct, roles) do
    struct
    |> changeset
    |> put_assoc(:roles, roles)
  end

  defp hash_password(%Ecto.Changeset{valid?: true} = changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(password))
  end
  defp hash_password(changeset), do: changeset
end
