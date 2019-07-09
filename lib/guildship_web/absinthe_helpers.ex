defmodule GuildshipWeb.AbsintheHelpers do
  require Absinthe.Schema.Notation

  def from_global_id(global_id, schema \\ GuildshipWeb.Schema) do
    Absinthe.Relay.Node.from_global_id(global_id, schema)
  end

  def to_global_id(node_type, source_id, schema \\ GuildshipWeb.Schema) do
    Absinthe.Relay.Node.to_global_id(
      node_type,
      source_id,
      schema
    )
  end

  def handle_errors(fun) do
    fn source, args, info ->
      case Absinthe.Resolution.call(fun, source, args, info) do
        {:error, %Ecto.Changeset{} = changeset} -> format_changeset(changeset)
        val -> val
      end
    end
  end

  def format_changeset(changeset) do
    # {:error, [email: {"has already been taken", []}]}
    errors =
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    {:error,
     %{
       message: "Validation failed",
       changeset: %{
         errors: errors
       }
     }}
  end

  @doc """
  Wraps resolver in GuildshipWeb.AbsintheHelpers.handle_errors/1

  ```elixir
  resolve_safe &My.Resolvers.resolver/3
  ```
  """
  defmacro resolve_safe(fn_ast) do
    quote do
      Absinthe.Schema.Notation.resolve(handle_errors(unquote(fn_ast)))
    end
  end
end
