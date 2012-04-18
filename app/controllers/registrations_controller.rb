class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!, :only => :token

  def new
    super
  end

  
  def create
    @user = User.new(params[:user])
    if params[:user][:reference_code] != "I love comic"
      flash[:alert] = "You don't have a valid reference code"
      render :action => :new
    else 
      if @user.save
        flash[:notice] = "You have signed up successfully. Please Login."
        redirect_to new_user_session_path
      else
        render :action => :new
      end
    end
  end

  def update
    super
  end
  
  protected

  def after_sign_up_path_for(resource)
    movies_path
  end
end 