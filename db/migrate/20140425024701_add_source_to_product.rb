class AddSourceToProduct < ActiveRecord::Migration
  def change
    add_column :products, :source, :string, default: 'NORMAL'
  end
end
