class FoodEntriesController < ApplicationController
  before_action :ensure_logged_in, :authorize_user

  def new
    @food_entry = FoodEntry.new
    @meals = user_meals.map { |meal| [meal.name, meal.id] }
  end

  def index
    @food_entries = current_user.food_entries
  end

  def create
    result = FoodEntryManagement::Create.call(create_food_entry_params)
    if result.success?
      redirect_to user_food_entries_path(current_user)
    else
      @food_entry = FoodEntry.new
      @meals = user_meals.map { |meal| [meal.name, meal.id] }
      flash.now[:error] = result.failure
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @food_entry = FoodEntry.find(params[:id])
    @meals = user_meals.map { |meal| [meal.name, meal.id] }
  end

  def update
    result = FoodEntryManagement::Update.call(update_food_entry_params)
    if result.success?
      flash[:success] = "Successfuly updated entry!"
      redirect_to user_food_entries_path(current_user)
    else
      @food_entry = FoodEntry.find(params[:id])
      @meals = user_meals.map { |meal| [meal.name, meal.id] }
      flash.now[:error] = result.failure
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    result = FoodEntryManagement::Delete.call(delete_food_entry_params)
    if result.success?
      redirect_to user_food_entries_path(current_user)
    else
      flash.now[:error] = result.failure
      render :index, status: :unprocessable_entity
    end
  end

  private

  def ensure_logged_in
    redirect_to new_sessions_path unless logged_in?
  end

  def authorize_user
    user = User.find(params[:user_id])
    redirect_to user_food_entries_path(current_user) unless user == current_user
  end

  def user_meals
    @_user_meals ||= current_user.meals
  end

  def create_food_entry_params
    @create_food_entry_params ||= entry_params.merge(user: current_user)
  end

  def update_food_entry_params
    food_entry = FoodEntry.find(params[:id])
    @update_food_entry_params ||= {user: current_user, food_entry: food_entry, changes: entry_params}
  end

  def delete_food_entry_params
    food_entry = FoodEntry.find(params[:id])
    @delete_food_entry_params ||= {user: current_user, food_entry: food_entry}
  end

  def entry_params
    entry_params = params.require(:food_entry).permit(:name, :calories, :eaten_at, :meal).to_h.symbolize_keys

    entry_params[:meal] = user_meals.find(entry_params[:meal])

    @entry_params ||= entry_params.transform_values { |value| value.blank? ? nil : value }
  end
end
