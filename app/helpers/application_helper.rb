module ApplicationHelper

    def find_user(user_id)
        sql = "SELECT * FROM users WHERE id = #{user_id}"
        users = ActiveRecord::Base.connection.exec_query(sql)
          
    end 

    def article_join_user(article_id)
    
        #sql= "SELECT * FROM articles  INNER JOIN users ON articles.user_id = users.id where articles.id=#{article_id}"
       
        article_join = ActiveRecord::Base.connection.exec_query("call get_user_details(#{article_id})")
    
        ActiveRecord::Base.clear_all_connections!
        return article_join 
      
 
    end
    def all_articles
      
        all_articles = ActiveRecord::Base.connection.exec_query("call get_articles")
        ActiveRecord::Base.clear_all_connections!
 
    end

    def get_category_articles(category_id)
        category_articles = ActiveRecord::Base.connection.exec_query("call count_all_articles_of_categories(#{category_id})")
        ActiveRecord::Base.clear_all_connections!
        return category_articles
    end 

    def get_user_articles(user_id)
        
        user_articles = ActiveRecord::Base.connection.exec_query("call count_allArticles_of_user_by_id(#{user_id})")
        ActiveRecord::Base.clear_all_connections!
        return user_articles
    end

end
