class ApplicationController < ActionController::Base
    helper_method :current_user,:logged_in?
    helper :all


    
    def current_user
        #one line code...
        #@current_user ||= User.find(session[:user_id]) if session["user_id"]

        #or ...
       
        if session["user_id"]
            @current_user ||= User.find(session[:user_id])
        end
            
    end
    def logged_in?
        !!current_user
    end

    def require_user
        if !logged_in?
            flash[:alert] = "you must be logged in first"
            redirect_to login_path
        end

    end

  

end
