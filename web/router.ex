defmodule TinyFair.Router do
  use TinyFair.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :invite_only do
    plug TinyFair.Auth.InviteOnly
  end

  scope "/", TinyFair do
    pipe_through :browser # Use the default browser stack

    resources "/account", AccountController, singleton: true,
      only: [:show] do
      # resources "/contacts"
    end

    resources "/marketplace", MarketplaceController, singleton: true, only: [:show] do
      resources "/products", ProductController,
        only: [:index]
    end

    get "/", PageController, :index

    resources "/session", SessionController, singleton: true,
      only: [:new, :create, :delete]
    get "/session", SessionController, :delete # handy logout

    get "/invite", InviteController, :activation_page
    get "/invite-rules", InviteController, :invite_rules
    post "/invite", InviteController, :activate
  end

  scope "/", TinyFair do
    pipe_through [:browser, :invite_only]

    resources "/registration", RegistrationController, singleton: true,
      only: [:new, :create]
  end
end
