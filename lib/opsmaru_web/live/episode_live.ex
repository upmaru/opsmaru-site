defmodule OpsmaruWeb.EpisodeLive do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Courses

  def mount(%{"id" => episode_slug}, _session, socket) do
    #episode = Courses.show_episode(episode_slug)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div></div>
    """
  end
end
