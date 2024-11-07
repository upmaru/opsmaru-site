defmodule Opsmaru.Content.Post.Manager do
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Post

  def list(options \\ [cache: true]) do
    cache? = Keyword.get(options, :cache)

    Sanity.query(
      ~S"""
      *[_type == "post"]
      """,
      %{}
    )
    |> Sanity.request!(request_opts())
    |> case do
      %Sanity.Response{body: %{"result" => posts}} ->
        posts =
          Enum.map(posts, fn post_params ->
            Post.parse(post_params)
          end)

        if cache? do
          Enum.map(posts, fn post ->
            {{:posts, post.slug}, post}
          end)
          |> Enum.into(%{})
          |> Cache.put_all()
        end

        posts

      error ->
        error
    end
  end

  def show(slug) do
    Cache.get({:posts, slug})
    |> case do
      nil ->
        fetch(slug)

      post ->
        post
    end
  end

  def fetch(slug) do
    Sanity.query(
      ~S"""
      *[_type == "post"]
      """,
      %{"slug" => slug}
    )
    |> Sanity.request!(request_opts())
    |> case do
      %Sanity.Response{body: %{"result" => [post_params]}} ->
        post = Post.parse(post_params)

        Cache.put({:posts, post.slug}, post)

        post

      error ->
        error
    end
  end
end
