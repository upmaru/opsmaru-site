defmodule Opsmaru.Content.Page.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Sanity.Response

  alias Opsmaru.Cache
  alias Opsmaru.Content.Page

  @ttl :timer.hours(1)

  @spec show(String.t(), Keyword.t()) :: %{data: %Page{}, perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def show(slug, options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    page =
      ~S"""
      *[_type == "page" && slug.current == $slug][0]{
        ...,
        "cover": {"url": cover.asset -> url, "alt": cover.alt},
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
      |> Sanity.query(%{"slug" => slug}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Page.parse()

    sections =
      page.sections
      |> Enum.map(&process_section/1)

    %Response{data: %{page | sections: sections}, perspective: perspective}
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
