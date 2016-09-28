defmodule TinyFair.Factory do
  use ExMachina.Ecto, repo: TinyFair.Repo

  def user_factory do
    %TinyFair.User{
      username: "Jane Smith",
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end

  def product_factory do
    %TinyFair.Product{
      name: sequence(:name, &"Product-#{&1}"),
      desc: "This is awesome product! I swear!",
      owner: build(:user),
      image_url: "http://placehold.it/50x50"
    }
  end
end
