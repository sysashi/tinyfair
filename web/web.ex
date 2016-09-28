defmodule TinyFair.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use TinyFair.Web, :controller
      use TinyFair.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      TinyFair.Web.common_aliases
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: TinyFair

      import Ecto
      import Ecto.Query

      import TinyFair.Router.Helpers
      import TinyFair.Gettext

      import TinyFair.ControllerHelpers
      TinyFair.Web.common_aliases
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates", namespace: TinyFair

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import TinyFair.Router.Helpers
      import TinyFair.ErrorHelpers
      import TinyFair.Gettext

      TinyFair.Web.common_aliases
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias TinyFair.Repo
      import Ecto
      import Ecto.Query
      import TinyFair.Gettext
    end
  end

  def aliases do
    quote do
      TinyFair.Web.common_aliases
    end
  end

  defmacro common_aliases do
    quote do
      alias TinyFair.{
        User,
        UserRole,
        Invite,
        Product,
        Repo
      }
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
