Rails.application.routes.draw do
  root "home#welcome"
  resources "users"
  resource "sessions", only: [:new, :create, :destroy]
end
