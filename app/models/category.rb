class Category < ActiveRecord::Base
  has_many :products
  
  has_many :children, class_name: 'Category'
  belongs_to :parent, class_name: 'Category'

  validates_uniqueness_of :name, :scope => :parent_id
  
  # class mothods ..................................................
  class << self
    # string format: category 1 >> category 2 ...
    def create_by_string(category_string, separator = '>')
      return nil if !category_string || category_string.blank?
      category_string.split(separator).inject(nil) do |category, name|
        if name.blank?
          category = category
        else
          parent_id = category ? category.id : 0
          new_category = Category.where(:name => name, :parent_id => parent_id).first
          unless new_category
            new_category = Category.new
            new_category.name = name
            new_category.parent = category if category
            new_category.save!
          end
          category = new_category
        end
      end
    end
  end
end
