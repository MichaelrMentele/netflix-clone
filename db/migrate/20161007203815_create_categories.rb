class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :tag
      t.timestamps
    end

    add_column :videos, :category_id, :integer
  end
end
