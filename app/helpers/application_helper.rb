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
end
