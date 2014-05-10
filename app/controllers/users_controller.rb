class UsersController < ApplicationController
  def pickers 
    @pickers = User.where("role='picker'").where.not(id: current_user.id) 
  end
end
