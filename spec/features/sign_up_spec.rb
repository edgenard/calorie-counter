require "rails_helper"

RSpec.feature "SignUps", type: :feature do
  scenario "successful signup" do
    visit "users/new"
    within("#new_user") do
      fill_in "Email", with: "test_user@example.com"
      fill_in "Password", with: "super_secret_password"
      fill_in "Password Confirmation", with: "super_secret_password"
      click_button "Create my account"
    end

    user = User.find_by(email: "test_user@example.com")
    expect(page).to have_content "Your Food Entries"
    expect(page).to have_current_path(user_path(user))
  end

  scenario "unsuccessful sign up" do
    visit "users/new"
    within("#new_user") do
      fill_in "Email", with: "test_user@example.com"
      fill_in "Password", with: "super_secret_password"
      fill_in "Password Confirmation", with: "password doesn't match"
      click_button "Create my account"
    end
    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
