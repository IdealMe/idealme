class AddSlugToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :slug, :string
  end
end
