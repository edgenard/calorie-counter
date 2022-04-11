class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :max_calories_per_day

      t.timestamps
    end
  end
end
