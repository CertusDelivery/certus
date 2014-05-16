module Customer
  class CustomerController < ApplicationController
    skip_before_filter :require_picker_user
        
    layout "customer"
  end
end
