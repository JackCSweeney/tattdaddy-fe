class SessionsController <ApplicationController
  def create
    if params[:sign_in][:type] == "Sign In as User"
      user = User.find_by(email: params[:sign_in][:email])
      authenticate_user(user)
    elsif params[:sign_in][:type] == "Sign In as Artist"
      artist = ServiceFacade.new.artists.find { |artist|artist.email == params[:sign_in][:email] }
      authenticate_artist(artist)
    end
  end

  def destroy
    # request BE to delete session here
    redirect_to root_path
  end

  private
  def authenticate_user(user)
    if user && user.authenticate(params[:sign_in][:password])
      redirect_to user_dashboard_path(user)
    else
      redirect_to root_path
      flash[:error] = "Incorrect credentials"
    end
  end

  def authenticate_artist(artist)
    if artist && artist.authenticate(params[:sign_in][:password])
      redirect_to artist_dashboard_path(artist)
    else
      redirect_to root_path
      flash[:error] = "Incorrect credentials"
    end
  end
end