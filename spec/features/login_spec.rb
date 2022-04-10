require "rails_helper"

RSpec.feature "Logins", type: :feature do
  let(:user) { create(:user) }
  scenario "Successful Login" do
    visit "/sessions/new"
    within("#new_session") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_button "Login"
    end
    expect(page).to have_content "Your Food Entries"
    expect(page).to have_current_path(user_path(user))
  end

  scenario "Unsuccessful Login" do
    visit "/sessions/new"
    within("#new_session") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password + "hi"

      click_button "Login"
    end

    expect(page).to have_content "Invalid Credentials"
  end

  scenario "When already logged in it redirects to user's page" do
    visit "/sessions/new"
    within("#new_session") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_button "Login"
    end

    visit "/sessions/new"

    expect(page).to have_content "Your Food Entries"
    expect(page).to have_current_path(user_path(user))
  end

  scenario "Logging Out" do
    visit "/sessions/new"
    within("#new_session") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_button "Login"
    end

    expect(page).to have_content "Your Food Entries"
    expect(page).to have_current_path(user_path(user))

    click_on "Log out"

    expect(page).to have_content "Logged Out"
    expect(page).to have_current_path(root_path)
  end
end
