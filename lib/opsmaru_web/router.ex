defmodule OpsmaruWeb.Router do
  use OpsmaruWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {OpsmaruWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OpsmaruWeb do
    pipe_through :browser

    get "/blog/rss.xml", Blog.RssController, :index

    live_session :default,
      on_mount: [{OpsmaruWeb.NavigationHook, :main}] do
      live "/", HomeLive

      live "/blog", BlogLive.Index
      live "/blog/:id", BlogLive

      live "/how-to", CourseLive.Index
      live "/how-to/:id", CourseLive
      live "/how-to/:course_id/:id", EpisodeLive

      live "/our-product/pricing", PricingLive

      live "/legal/:id", LegalLive
    end

    # get "/", PageController, :home
    # get "/our-product", PageController, :product
    # get "/our-product/pricing", PageController, :pricing
    # get "/legal/privacy-policy", PageController, :privacy

    # get "/blog", PostController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", OpsmaruWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:opsmaru, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: OpsmaruWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
