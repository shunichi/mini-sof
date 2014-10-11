class AddAnswersCountToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :answers_count, :integer, default: 0
    add_index :questions, :answers_count
  end
end
