defmodule Opsmaru.Content.Page.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Page

  @ttl :timer.hours(1)

  @decorate cacheable(cache: Cache, key: {:pages, slug}, opts: [ttl: @ttl])
  def show(slug) do
    ~S"""
    *[_type == "page" && slug.current == $slug][0]{
      ...,
      "sections": *[ _type == "pageSection" && references(^._id) ]{
        ...,
        "contents": *[ _type == "pageContent" && references(^._id) ]{
          ...,
          "markdown": markdown.asset -> url
        },
        "cards": *[ _type == "pageCard" && references(^._id) ]{
          ...,
          card -> {..., "cover": {"url": cover.asset -> url, "alt": cover.alt}}
        }
      }
    }
    """
    |> Sanity.query(%{"slug" => slug}, perspective: "published")
    |> Sanity.request!(sanity_request_opts())
    |> Sanity.result!()
    |> case do
      nil ->
        nil

      page ->
        page = Page.parse(page)

        sections =
          page.sections
          |> Enum.map(&process_section/1)

        %{page | sections: sections}
    end
  end

  defp process_section(section) do
    contents = Enum.map(section.contents, &process_content/1)

    %{section | contents: contents}
  end

  defp process_content(content) do
    full_markdown =
      if content.markdown do
        Req.get!(content.markdown).body
      else
        nil
      end

    %{content | markdown: full_markdown}
  end
end
