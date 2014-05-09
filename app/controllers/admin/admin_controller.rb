module Admin
  class AdminController < ApplicationController
    before_filter :require_admin_user

    layout "admin"
  end
end
