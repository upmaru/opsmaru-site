defmodule OpsmaruWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use OpsmaruWeb, :html

  alias OpsmaruWeb.BaseComponents

  embed_templates "page_html/*"
end
