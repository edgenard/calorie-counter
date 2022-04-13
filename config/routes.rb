Rails.application.routes.draw do
  root "home#welcome"
  resources "users" do
    resources "food_entries"
  end
  resource "sessions", only: [:new, :create, :destroy]
end
