defmodule TinyFair.InviteHelper do
  require TinyFair.Web
  TinyFair.Web.common_aliaces

  @valid_for (3600 * 24) * 31 # seconds
  def registrable?(%Invite{token: token}), do: registrable?(token)

  def registrable?(token) when is_binary(token) do
    with \
      {:ok, invite_id} <- Phoenix.Token.verify(TinyFair.Endpoint, "invite", token, max_age: @valid_for),
      invite when not is_nil(invite) <- Repo.get(Invite, invite_id) do
            invite = invite |> Repo.preload(:invitee)
            is_nil(invite.activated_at) and is_nil(invite.invitee)
      else
        _ -> false
    end
  end

  def build(user, params, valid_for \\ @valid_for) do
    invite =
      Ecto.build_assoc(user, :invites)
      |> Invite.create_changeset
      |> Repo.insert!

    expiry_date = time_add(Ecto.DateTime.utc, valid_for)
    token = Phoenix.Token.sign(TinyFair.Endpoint, "invite", invite.id)

    invite
    |> Invite.update_changeset(%{token: token, expiry: expiry_date})
    |> Repo.update!
  end

  # FIXME
  defp time_add(time, seconds) do
    time
    |> Ecto.DateTime.to_erl
    |> :calendar.datetime_to_gregorian_seconds
    |> Kernel.+(seconds)
    |> :calendar.gregorian_seconds_to_datetime
    |> Ecto.DateTime.from_erl
  end
end
