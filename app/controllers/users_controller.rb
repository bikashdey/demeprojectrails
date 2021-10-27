class UsersController<ApplicationController

    before_action :set_user, only: [:show,:edit,:update,:destroy]
    before_action :require_user, only:[:edit,:update]
    before_action :require_same_user, only:[:edit,:update,:destroy]

    def show

    end

    def index
        @users = User.all
        # sql = "select * from users;"
        # @users = ActiveRecord::Base.connection.exec_query(sql)
       
    end

    def new
        @user=User.new
    end

    def create 
        @user = User.new(user_params)

        if @user.save
            flash[:notice] = "Welcome \"#{@user.username}\" you have succesfully signup "
            redirect_to login_path
        else
            render 'new'

        end
    end

    def edit

    end

    def update
        @user=User.find(params[:id])
        if @user.update(user_params)
            flash[:notice] = "your accout is updated"
            redirect_to articles_path
        else
            render 'edit'
        end

    end

    def destroy
        @user.destroy
        session[:user_id] = nil if @user == current_user
        flash[:notice] = "Account and all associated articles successfully deleted"
        redirect_to @user

    end

    private
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:alert]= "you cant edit or update"
            redirect_to @user #show page
        end

    end
end
