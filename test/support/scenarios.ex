defmodule Opsmaru.Scenarios do
  def setup_finch(_context) do
    test_finch = Application.get_env(:opsmaru, :test_finch)

    Finch.start_link(name: test_finch)

    :ok
  end
end
