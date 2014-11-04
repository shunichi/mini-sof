class AddCachedTagListToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :cached_tag_list, :string
  end
end
