class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :model
      t.string :action
      t.string :url
      t.boolean :success
      t.string :code
      t.text :info
      t.text :response
      t.timestamps
    end
  end
end
