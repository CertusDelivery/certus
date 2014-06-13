class User < ActiveRecord::Base

  ROLES = %w(admin picker router)

  has_many :delivery_picker_ships, foreign_key: 'picker_id' 
  has_many :deliveries, through: :delivery_picker_ships
  has_many :route_list, class_name:'Delivery', foreign_key: 'router_id' 

  validates_presence_of :first_name, :last_name, :email, :login
  validates_inclusion_of :role, :in => ROLES


  scope :active, -> { where("activated_at IS NOT NULL") }

  ROLES.each do |item|
    define_method "#{item}?" do
      role == item
    end

    define_method "#{item}!" do
      update_attribute :role, item
    end
  end

  acts_as_authentic do |config|
    config.validate_email_field = false
    config.logged_in_timeout = 30.minutes
    # config.merge_validates_format_of_login_field_options :with => /\A\w[\w\.\-_@ ]+$/, :on => :create
  end

  def to_s
    name_with_login
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def name_with_login
    "#{first_name} #{last_name} (#{login})"
  end
end
