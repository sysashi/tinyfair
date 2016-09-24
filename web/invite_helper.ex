defmodule TinyFair.InviteHelper do
  require TinyFair.Web
  TinyFair.Web.common_aliases

  @valid_for (3600 * 24) * 31 # seconds
  def registrable(token), do: registrable?(token, result: true)

  def registrable?(token, opts \\ [])

  def registrable?(%Invite{token: token}, opts), do: registrable?(token, opts)

  def registrable?(token, opts) when is_binary(token) do
    return? = Keyword.get(opts, :result, false)
    with \
      {:ok, invite_id} <- Phoenix.Token.verify(TinyFair.Endpoint, "invite", token, max_age: @valid_for),
      invite when not is_nil(invite) <- Repo.get(Invite, invite_id) do
            invite = invite |> Repo.preload(:invitee)
            r? = is_nil(invite.activated_at) and is_nil(invite.invitee)
            if return?, do: {r?, invite}, else: r?
      else
        invite -> if return?, do: {false, invite}, else: false
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
