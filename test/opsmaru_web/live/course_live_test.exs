defmodule OpsmaruWeb.CourseLiveTest do
  use OpsmaruWeb.ConnCase, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  import Opsmaru.Scenarios
  import Phoenix.LiveViewTest

  alias Opsmaru.Courses

  setup [:setup_finch]

  describe "course detail page" do
    test "can visit course detail page", %{conn: conn} do
      use_cassette "course_live_test", match_requests_on: [:query] do
        categories = Courses.list_categories(featured: true)
        courses = Enum.flat_map(categories, fn category -> category.courses end)

        course = Enum.find(courses, fn course -> course.slug == "setup-aws-infrastructure" end)

        {:ok, lv, _html} = live(conn, ~p"/how-to/#{course.slug}")

        assert render(lv) =~ "Setup AWS Infrastructure"

        assert render(lv) =~ "Don&#39;t have an account?"
      end
    end
  end
end
