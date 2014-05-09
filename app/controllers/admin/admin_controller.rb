module Admin
  class AdminController < ApplicationController
    skip_before_filter :require_picker_user
    before_filter :require_admin_user

    layout "admin"
  end
end
