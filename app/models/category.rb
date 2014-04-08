class Category < ActiveRecord::Base
  has_many :products
  
  has_many :children, class_name: 'Category'
  belongs_to :parent, class_name: 'Category'

  validates_uniqueness_of :name
  
  # class mothods ..................................................
  class << self
    # string format: category 1 >> category 2 ...
    def create_by_string(category_string, separator = '>')
      return nil if category_string == nil || category_string.blank?
      category_string.split(separator).inject(nil) do |category, name|
        return category if name.blank?
        new_category = Category.find_by_name(name)
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
