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
    pipe_through [:browser, :invite_only]

    resources "/registration", RegistrationController, singleton: true,
      only: [:new, :create]
  end

  scope "/", TinyFair do
    pipe_through :browser

    get "/", PageController, :index
    resources "/session", SessionController, singleton: true, only: [:new, :create, :delete]
    get "/session", SessionController, :delete # handy logout
    get "/invite", InviteController, :activation_page
    get "/invite-rules", InviteController, :invite_rules
    post "/invite", InviteController, :activate
  end

  scope "/", TinyFair do
    pipe_through [:browser, :user_only] # Use the default browser stack
    scope "/account" do
      get "/", AccountController, :show
      get "/contacts", AccountController, :contacts
      get "/settings", AccountController, :settings
      get "/orders", AccountController, :orders # User's orders
      put "/update", AccountController, :update
      patch "/update", AccountController, :update
      scope "/", as: :account do
        resources "/products", ProductController, except: [:show] do
          resources "/orders", OrderController, only: [:index, :update, :edit]
        end
        get "/products/orders", ProductController, :purchase_orders
        get "/products/stash", ProductController, :stash
      end
    end

    scope "/marketplace" do
      get "/", MarketplaceController, :index
      scope "/products", Marketplace, as: "product" do
        get "/:id/get", OrderController, :new
        post "/:id/order", OrderController, :create
      end
    end
  end
end
