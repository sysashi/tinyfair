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

    resources "/orders", OrderController

    resources "/session", SessionController, singleton: true,
      only: [:new, :create, :delete]
    get "/session", SessionController, :delete # handy logout

    get "/invite", InviteController, :activation_page
    get "/invite-rules", InviteController, :invite_rules
    post "/invite", InviteController, :activate
  end

  scope "/", TinyFair do
    pipe_through [:browser, :user_only] # Use the default browser stack

   # scope "/account" do

   #   # TODO merege below two scopes
   #   scope "/contacts" do
   #     get "/", AccountController, :contacts
   #     put "/", AccountController, :update_contacts
   #     post "/", AccountController, :update_contacts
   #   end

   #   scope "/settings" do
   #     get "/", AccountController, :settings
   #     put "/", AccountController, :update_settings
   #     post "/", AccountController, :update_settings
   #   end

   #   resources "/products", ProductController, except: [:show] do
   #     get "/stash", ProductController, :stash
   #   end
   # end

    resources "/account", AccountController, singleton: true,
      only: [:show] do

      get "/products/stash", ProductController, :stash, as: :product
      resources "/products", ProductController, except: [:show]

      # Edit user contacts
      get "/contacts", Account.UserController, :contacts, as: "contacts"
      put "/contacts", Account.UserController, :update_contacts, as: "contacts"
      post "/contacts", Account.UserController, :update_contacts, as: "contacts"

      # Edit user settings (Notification types, etc)
      get "/settings", Account.UserController, :settings, as: "settings"
      put "/settings", Account.UserController, :update_settings, as: "settings"
      post "/settings", Account.UserController, :update_settings, as: "settings"
    end

    scope "/marketplace" do
      get "/", MarketplaceController, :index

      scope "/products", Marketplace, as: "product" do
        get "/:id/get", OrderController, :new
        post "/:id/order", OrderController, :create
        put "/:id/order", OrderController, :create
      end
    end
  end

  scope "/", TinyFair do
    pipe_through [:browser, :invite_only]

    resources "/registration", RegistrationController, singleton: true,
      only: [:new, :create]
  end
end
