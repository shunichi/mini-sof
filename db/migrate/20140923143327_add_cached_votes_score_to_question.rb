class AddCachedVotesScoreToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :cached_votes_score, :integer, :default => 0
    add_index  :questions, :cached_votes_score
  end
end
