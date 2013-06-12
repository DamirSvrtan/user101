class User < ActiveRecord::Base
	attr_accessible :name, :email, :password, :password_confirmation
	has_secure_password
	before_save { |user| user.email = email.downcase }
	before_save :create_remeber_token

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name, :presence => true, :uniqueness => true, :length => { :minimum => 3 }		
	validates :email, :presence => true, :uniqueness => { :case_sensitive => false }, :format => { :with => VALID_EMAIL_REGEX }
	validates :password, :presence => true, :length => { :minimum => 5 }
	validates :password_confirmation, presence: true
	
	private

		def create_remeber_token
			self.remember_token = SecureRandom.urlsafe_base64
		end

end
