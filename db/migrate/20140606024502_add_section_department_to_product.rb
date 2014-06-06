class AddSectionDepartmentToProduct < ActiveRecord::Migration
  def change
    add_column :products, :size3, :string
    add_column :products, :section, :string
    add_column :products, :department, :string
  end
end
