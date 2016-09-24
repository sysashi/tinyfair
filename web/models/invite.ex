defmodule TinyFair.Invite do
  use TinyFair.Web, :model

  schema "invites" do
    field :token
    field :expiry, Ecto.DateTime
    field :activated_at, Ecto.DateTime

    belongs_to :user_role, UserRole
    belongs_to :inviter, User, foreign_key: :user_id

    has_one :invitee, User, foreign_key: :invite_id

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token, :expiry, :activated_at, :user_role_id])
  end

  def update_changeset(struct, params) do
    struct
    |> changeset(params)
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token, :expiry, :user_id])
    |> validate_required([:user_id])
    |> assoc_constraint(:inviter)
  end
end
