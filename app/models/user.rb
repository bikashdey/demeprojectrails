class User < ApplicationRecord
    #to save automatic email to the small letter 
    before_save {self.email = email.downcase}
    has_many :articles,dependent: :destroy
    
    validates :username, presence: true, uniqueness: true, length: {minimum:3 ,maximum:100}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, uniqueness: true, length: {maximum:100},format: {with: VALID_EMAIL_REGEX}

    has_secure_password
end
