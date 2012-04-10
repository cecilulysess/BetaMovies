class User < ActiveRecord::Base
  # require the name is presence and unique
  validates :name, :presence => true, :uniqueness => true
  
  # require reenter a password and make them matched
  validates :password, :confirmation => true
  
  has_one :tracking_list
  
  attr_accessor :password_confirmation
  attr_reader   :password
  
  validate :password_must_be_present
  

  class << self
    def authenticate(name, password)
      if user = find_by_name(name)
        if user.hashed_password == encrypt_password(password, user.salt)
          user
        end
      end
    end
    
    def encrypt_password(password, salt)
      Digest::SHA2.hexdigest(password + "wibble" + salt)
    end
  end
  
  # override the default accessor
  def password=(password)
    @password = password
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  ##
  # the definition of privilege
  # 0 means normal user
  # 1 means administrator
  
  # let the setting method always set the value to 0
  def privilege=(privilege)
    write_attribute(:privilege, 0)
  end
  
  def privilege
    read_attribute(:privilege)
  end
  
  private 
    def password_must_be_present
      errors.add(:password, "Missing Password") unless hashed_password.present?
    end
    
    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
end
