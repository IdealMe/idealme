class AddRogerLoveToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :roger_love, :boolean, default: false
  end
end
