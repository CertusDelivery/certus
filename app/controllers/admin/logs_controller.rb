module Admin
  class LogsController < AdminController
    def index
      @logs = Log.products.page(params[:page])
    end

    def show
      @log = Log.find(params[:id])
    end

    def csv_export
      if params[:a] 
        logs = Log.where(action: params[:a])
      end
      logs ||= Log.all
      csv_string = CSV.generate do |csv|
        csv << ['Time','Model','Action','Info','Response','Success','Code']
        logs.each do |l|
          csv << [l.created_at, l.model.upcase, l.action.upcase, l.info, l.response, l.success, l.code]
        end
      end
      send_data csv_string,  
                :type=>'text/csv; charset=iso-8859-1; header=present',  
                :disposition => "attachment; filename=#{Time.new.strftime('%Y%m%d%H%M%S')}-logs.csv"

    end
  end
end
