defmodule GuildshipWeb.Absinthe.IDTranslator do
  @behaviour Absinthe.Relay.Node.IDTranslator
  alias Guildship.HashID

  def to_global_id(type_name, source_id, _schema) do
    hashid = HashID.encode(source_id)
    global_id_string = hashid <> ":" <> type_name
    global_id = Base.encode64(global_id_string)
    {:ok, global_id}
  end

  def from_global_id(global_id, _schema) do
    decoded_from_base64 = Base.decode64!(global_id)

    case String.split(decoded_from_base64, ":", parts: 2) do
      [hash_id, type_name] ->
        source_id = HashID.decode(hash_id)
        {:ok, type_name, source_id}

      _ ->
        {:error, "Could not extract value from ID `#{inspect(global_id)}`"}
    end
  end
end
