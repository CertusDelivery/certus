module Admin
  class LogsController < AdminController
    def index
      @logs = Log.products.page(params[:page])
    end

    def show
      @log = Log.find(params[:id])
    end
  end
end
