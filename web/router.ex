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
    plug TinyFair.AuthPlugs.InviteOnly
  end

  pipeline :user_only do
    plug TinyFair.AuthPlugs.UserOnly
  end

  scope "/", TinyFair do
    pipe_through :browser

    get "/", PageController, :index

    resources "/session", SessionController, singleton: true,
      only: [:new, :create, :delete]
    get "/session", SessionController, :delete # handy logout

    get "/invite", InviteController, :activation_page
    get "/invite-rules", InviteController, :invite_rules
    post "/invite", InviteController, :activate
  end

  scope "/", TinyFair do
    pipe_through [:browser, :user_only] # Use the default browser stack

    resources "/account", AccountController, singleton: true,
      only: [:show] do

      # Edit user contacts
      get "/contacts", Account.UserController, :contacts, as: "contacts"
      put "/contacts", Account.UserController, :update_contacts, as: "contacts"
      post "/contacts", Account.UserController, :update_contacts, as: "contacts"

      # Edit user settings (Notification types, etc)
      get "/settings", Account.UserController, :settings, as: "settings"
      put "/settings", Account.UserController, :update_settings, as: "settings"
      post "/settings", Account.UserController, :update_settings, as: "settings"
    end

    resources "/marketplace", MarketplaceController, singleton: true, only: [:show] do
      resources "/products", ProductController,
        only: [:index]
    end
  end

  scope "/", TinyFair do
    pipe_through [:browser, :invite_only]

    resources "/registration", RegistrationController, singleton: true,
      only: [:new, :create]
  end
end
