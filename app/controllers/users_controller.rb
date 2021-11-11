class UsersController<ApplicationController

    before_action :set_user, only: [:show,:edit,:update,:destroy]
    before_action :require_user, only:[:edit,:update]
    #before_action :require_same_user, only:[:edit,:update,:destroy]

    def show

    end

    def index
        @users = ActiveRecord::Base.connection.exec_query("call get_all_user")
        ActiveRecord::Base.clear_all_connections!
        # sql = "select * from users;"
        # @users = ActiveRecord::Base.connection.exec_query(sql)
       
    end

    def new
        @user=User.new
    end

    def create 
        
        user_name = params[:user][:username]
        user_email = params[:user][:email]
        user_password = params[:user][:password]
        @user = ActiveRecord::Base.connection.exec_query("call create_user('#{user_name}','#{user_email}','#{user_password}',@userid)")
        @user_id_return = ActiveRecord::Base.connection.exec_query("select @userid")
        user_id_return = @user_id_return.first['@userid']
        ActiveRecord::Base.clear_all_connections!

        user_username = ActiveRecord::Base.connection.exec_query("call get_user_username_return_byId(#{user_id_return})")
        ActiveRecord::Base.clear_all_connections!


        flash[:notice] = "Welcome \"#{user_username.first['username']}\" you have succesfully signup "
        redirect_to login_path

        # if @user.save
        #     flash[:notice] = "Welcome \"#{@user.username}\" you have succesfully signup "
        #     redirect_to login_path
        # else
        #     render 'new'

        # end
    end

    def edit

    end

    def update

        user_id = params[:id]
        user_name = params[:username]
        user_email = params[:email]
        @user = ActiveRecord::Base.connection.exec_query("call update_user(#{user_id},'#{user_name}','#{user_email}')")
        ActiveRecord::Base.clear_all_connections!
        flash[:notice] = "your account is updated"
        redirect_to user_path

        # if @user.update(user_params)
        #     flash[:notice] = "your account is updated"
        #     redirect_to articles_path
        # else
        #     render 'edit'
        # end

    end

    def destroy
        user_id = params[:id]
        @user = ActiveRecord::Base.connection.exec_query("call delete_user(#{user_id})")
        ActiveRecord::Base.clear_all_connections!
        session[:user_id] = nil if @user == current_user['id']
        flash[:notice] = "Account and all associated articles successfully deleted"
        redirect_to user_path

    end

    private
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

    def set_user
        user_id = params['id']
        @user = ActiveRecord::Base.connection.exec_query("call find_user_byID(#{user_id})")
        ActiveRecord::Base.clear_all_connections!
        
    end

    def require_same_user
        if current_user['id'] != @user && !current_user.admin?
            flash[:alert]= "you can't edit or update must be looged_in user and admin both are same user and admin both.. "
            redirect_to user_path #show page
        end

    end
end
