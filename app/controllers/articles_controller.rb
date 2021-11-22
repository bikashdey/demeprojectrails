class ArticlesController < ApplicationController
    
    before_action :set_article, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:show,:index]
    before_action :require_same_user, only:[:edit,:update,:destroy]
    def show
        
    end

    def index
       
        #@articles = Article.all
        #sql = "select * from articles;"
        @articles = ActiveRecord::Base.connection.exec_query("call get_articles")
        ActiveRecord::Base.clear_all_connections!

     
       # @articles = Article.paginate(page: params[:page],per_page: 5)
       
        
    end
    def new
        @article = Article.new

    end

    def show
    end

    def create
        
        # @article = Article.new(article_params)
        # @article.user =current_user
        # if @article.save
        #     flash[:notice] = "Article was created successfully.."
            
        # else
        #     render 'new'
        # end




        article_title = params[:title]
        article_description = params[:description]
        
        @article = ActiveRecord::Base.connection.exec_query("call create_article_insert('#{article_title}','#{article_description}', @val)")
      
        @out = ActiveRecord::Base.connection.exec_query("select @val")
        article_id = @out.first['@val']
        ActiveRecord::Base.clear_all_connections!


        # create SP for updating user_id column in Article table.
        # update articles set user_id = userid where id = article_id;
        # ActiveRecord::Base.connection.exec_query("call update_userid_of_articles(#{current_user['id']},#{article_id})")
        # ActiveRecord::Base.clear_all_connections!

        # inserting article_id and category_id in article_categories table......
        category_id = params[:category_ids][1]

        @insert_articleId_categoryId = ActiveRecord::Base.connection.exec_query("call insert_articleId_and_categoryId_into_article_categories(#{article_id},#{category_id})")
        ActiveRecord::Base.clear_all_connections!

        redirect_to articles_path

        
    end

    def edit
        
    end

    def update
        
        article_title = params[:title]
        article_description = params[:description]
        article_category = params[:category_ids][1]
        @article = ActiveRecord::Base.connection.exec_query("call edit_article('#{article_title}','#{article_description}','#{article_category}')")
        ActiveRecord::Base.clear_all_connections!
        flash[:notice] = "Article was updated successfully.."
        redirect_to articles_path
        # if @article.update(article_params)
            
        #     flash[:notice] = "Article was updated successfully.."
        #     redirect_to @article

        # else
        #     render 'edit'
            
        # end
    end

    def destroy
        # @article = Article.find(params[:id])
        # @article.destroy
        article_id = params[:id]
        @article = ActiveRecord::Base.connection.exec_query("call delete_article(#{article_id})")
        ActiveRecord::Base.clear_all_connections!
        flash[:notice] = "Article was deleted successfully.."
        redirect_to articles_path
    end

    private

    def set_article
        #@article = Article.find(params[:id])
        article_id= params[:id]
       
        @article = ActiveRecord::Base.connection.exec_query("call show_article_details_by_id(#{article_id})").first
    
        ActiveRecord::Base.clear_all_connections!
    end

    def article_params
     
        params.require(:article).permit(:title, :description, category_ids: [])
    end

    def require_same_user
        if current_user['id'] != @article['user_id'] && !current_user.admin?
            flash[:alert] = "you can only edit ,delete,and update your own articles"
        end
    end

end
