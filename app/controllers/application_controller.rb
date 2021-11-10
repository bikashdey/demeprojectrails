class ApplicationController < ActionController::Base
    helper_method :current_user,:logged_in?
    helper :all


    
    def current_user
        #one line code...
        #@current_user ||= User.find(session[:user_id]) if session["user_id"]

        #or ...
       
        if session["user_id"]
            # ||= means if @current_user is null then find  from [ User.find(session[:user_id]) and assign to @current_user]
            @current_user ||= User.find(session[:user_id])
        end
            
    end
    def logged_in?
        # !! means true...
        !!current_user
    end

    def require_user
        if !logged_in?
            flash[:alert] = "you must be logged in first"
            redirect_to login_path
        end

    end

  

end
