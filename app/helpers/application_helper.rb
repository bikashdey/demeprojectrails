module ApplicationHelper

    def find_user(user_id)
   
        sql = "SELECT * FROM users WHERE id = #{user_id}"
        @users = ActiveRecord::Base.connection.exec_query(sql)
        
    
    end

end
