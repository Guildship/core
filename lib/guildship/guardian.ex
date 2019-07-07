defmodule Guildship.Guardian do
  use Guardian, otp_app: :guildship

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    id = claims["sub"]
    resource = Guildship.Accounts.get_user_by_id(id)

    case resource do
      {:ok, resource} -> {:ok, resource}
      _ -> {:error, "Could not get resource from claims"}
    end
  end
end
