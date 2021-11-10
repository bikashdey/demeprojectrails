class CategoriesController < ApplicationController
    #before_action :require_admin, except: [:index,:show]
    def new
        @category = Category.new
    end

    def create
        @category = Category.new(category_params)
        if @category.save
            flash[:notice] = "Category was successfully created"
            redirect_to categories_path
        else
            render 'new'
        end
    end

    def index
        
        @categories = ActiveRecord::Base.connection.exec_query("call get_categories")
        ActiveRecord::Base.clear_all_connections!
        #@categories = Category.paginate(page: params[:page],per_page: 5)

    end

    def edit
        #@category =Category.find(params[:id])
        
        category_id = params[:id]
       
        @categories = ActiveRecord::Base.connection.exec_query("call show_category_details_by_id(#{category_id})").first
    
        ActiveRecord::Base.clear_all_connections!

    end

    def update
        #@category =Category.find(params[:id])
        
        category_id = params[:id]
        category_name = params[:name]
        @category = ActiveRecord::Base.connection.exec_query("call update_category(#{category_id},'#{category_name}')")
        ActiveRecord::Base.clear_all_connections!
        flash[:notice] = "Category was updated successfully.."
        redirect_to category_path
  
        # if @category.update(category_params)
            
        #     flash[:notice] = "Category was updated successfully.."
        #     redirect_to @category

        # else
        #     render 'edit'
            
        # end

    end

    def show
       
        category_id = params[:id]
        @category = ActiveRecord::Base.connection.exec_query("call show_category_by_id(#{category_id})")
        ActiveRecord::Base.clear_all_connections!
        @articles = ActiveRecord::Base.connection.exec_query("call count_all_articles_of_categories(#{category_id})")
        ActiveRecord::Base.clear_all_connections!
       
        

    end


    private
    def category_params
        params.require(:category).permit(:name)
    end


    def require_admin
        if !(logged_in? && current_user.admin?)
            flash[:alert] = "Only admin can perform that action"
            redirect_to categories_path
        end

    end
end
