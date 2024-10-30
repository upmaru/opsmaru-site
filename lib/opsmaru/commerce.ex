defmodule Opsmaru.Commerce do
  alias __MODULE__.Metadata

  defdelegate parse_metadata(params), to: Metadata, as: :parse
end
