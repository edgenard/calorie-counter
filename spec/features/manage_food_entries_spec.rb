require "rails_helper"

RSpec.feature "ManageFoodEntries", type: :feature do
  let(:user) { create(:user, :with_meals) }

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

    scenario "unsuccessfully creating a new food entry" do
      login_user(user)
      visit new_user_food_entry_path(user)

      within("#new_food_entry") do
        fill_in "Name", with: ""
        fill_in "Calories", with: 1000
        fill_in "Eaten At", with: "2022-04-10T19:33"
        select(Meal::BREAKFAST, from: "Meal")
        click_button "Create Food Entry"
      end

      expect(page).to have_content("name must be a string")
    end
  end

  feature "editing a food entry" do
    let!(:food_entry) { create(:food_entry, user: user, meal: user.meals.first) }
    scenario "successfully editing a food entry" do
      login_user(user)
      visit(user_food_entries_path(user))
      click_link "Edit"

      within("#food_entry_form") do
        fill_in "Name", with: "Other name"
        click_button "Edit Food Entry"
      end

      expect(page).to have_current_path(user_food_entries_path(user))
      expect(page).to have_content("Other name")
    end
  end

  # Skipping because there seems to be an issue with Capybara and working with Turbo Rails
  xfeature "deleting a food entry", js: true do
    let!(:food_entry) { create(:food_entry, user: user, meal: user.meals.first) }
    scenario "Successfully deleting a food entry" do
      login_user(user)
      visit(user_food_entries_path(user))
      expect(page).to have_content(food_entry.name.to_s)

      accept_alert do
        click_link "Delete"
      end

      expect(page).to have_current_path(user_food_entries_path(user))

      expect(page).to_not have_content(food_entry.name.to_s)
    end
  end

  feature "when trying to navigate to another users entries" do
    scenario "redirected to own entries" do
      other_user = create(:user)
      login_user(other_user)
      visit(user_food_entries_path(user))

      expect(page).to have_current_path(user_food_entries_path(other_user))
    end
  end

  def login_user(user)
    visit new_sessions_path
    within("#new_session") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_button "Login"
    end
  end
end
