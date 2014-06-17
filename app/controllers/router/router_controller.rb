module Router
  class RouterController < ApplicationController
    skip_before_filter :require_picker_user
    before_filter :require_router_user

    layout "router"
  end
end
