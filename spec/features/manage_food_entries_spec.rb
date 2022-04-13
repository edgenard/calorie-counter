require "rails_helper"

RSpec.feature "ManageFoodEntries", type: :feature do
  let(:user) { create(:user) }
  before do
    create(:meal, name: Meal::DINNER, user: user)
    create(:meal, name: Meal::LUNCH, user: user)
    create(:meal, name: Meal::BREAKFAST, user: user)
  end

  feature "ensure user is logged in" do
    scenario "redirects to log in page if user is not logged in" do
      visit new_user_food_entry_path(user)

      expect(page).to have_current_path(new_sessions_path)
    end
  end

  feature "create a food entry" do
    scenario "successfully create a new food entry" do
      login_user(user)
      visit new_user_food_entry_path(user)

      within("#new_food_entry") do
        fill_in "Name", with: "Hamburger"
        fill_in "Calories", with: 1000
        fill_in "Eaten At", with: "2022-04-10T19:33"
        select(Meal::BREAKFAST, from: "Meal")
        click_button "Create Food Entry"
      end

      expect(page).to have_current_path(user_food_entries_path(user))
      expect(page).to have_content("Hamburger")
      expect(page).to have_content("Calories: 1000")
      expect(page).to have_content("Eaten at: April 10, 2022 19:33")
      expect(page).to have_content("Meal: #{Meal::BREAKFAST}")
    end

    scenario ""
  end

  feature "editing a food entry"

  feature "deleting a food entry"

  def login_user(user)
    visit new_sessions_path
    within("#new_session") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_button "Login"
    end
  end
end
