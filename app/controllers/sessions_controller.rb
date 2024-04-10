class SessionsController <ApplicationController
  def create
    if params[:commit] == "Sign In as User"
      user = User.find_by(email: params[:email])
      authenticate_user(user)
    elsif params[:commit] == "Sign In as Artist"
      artist = ServiceFacade.new.artists.find { |artist|artist.email == params[:email] }
      authenticate_artist(artist)
    end
  end

  private
  def authenticate_user(user)
    if user && user.authenticate(params[:password])
      redirect_to user_dashboard_path(user)
    else
      redirect_to root_path
      flash[:error] = "Incorrect credentials"
    end
  end

  def authenticate_artist(artist)
    if artist && artist.authenticate(params[:password])
      redirect_to artist_dashboard_path(artist)
    else
      redirect_to root_path
      flash[:error] = "Incorrect credentials"
    end
  end
end