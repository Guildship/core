defmodule GuildshipWeb.Schema.AccountTypes do
  @moduledoc """
  GraphQL Schema for accounts
  """

  use Absinthe.Schema.Notation
  alias GuildshipWeb.Resolvers.AccountResolver

  enum :account_creation_status do
    value :ok
  end

  enum :credential_type do
    value :email, as: "email"
  end

  object :session do
    field :token, non_null(:string)
    field :user, non_null(:user)
  end

  object :account_creation_object do
    description("A creation")
    field :status, :account_creation_status
  end

  # TODO: Convert to an interface
  object :credential do
    field :type, non_null(:credential_type)
    field :username, non_null(:string)
  end

  object :user do
    field :id, non_null(:hashid)
    field :username, non_null(:string)

    field :credentials, list_of(:credential) do
      resolve &AccountResolver.get_credential/3
    end
  end
end
