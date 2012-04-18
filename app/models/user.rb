class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
         
  # Setup accessible (or protected) attributes for your model
  attr_accessible \
    :email, 
    :password, 
    :password_confirmation, 
    :remember_me
    
  def content_admin?
    puts "---------------------------------------------", privilege_level
    return privilege_level > 0
  end
end
