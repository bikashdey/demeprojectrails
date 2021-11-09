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
        @category =Category.find(params[:id])

    end

    def update
        @category =Category.find(params[:id])
  
        if @category.update(category_params)
            
            flash[:notice] = "Category was updated successfully.."
            redirect_to @category

        else
            render 'edit'
            
        end

    end

    def show
        @category = Category.find(params[:id])
        @articles = @category.articles

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
