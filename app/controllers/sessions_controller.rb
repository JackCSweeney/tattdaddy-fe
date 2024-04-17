class SessionsController <ApplicationController
  def create
    jwt_token = params[:token]

    decoded_token = JWT.decode(jwt_token, ENV['JWT_SECRET'], true, {algorithm: 'HS256'})
    if decoded_token.first['attributes']['user_id']
      user_id = decoded_token.first['attributes']['user_id']
      @user = User.new({id: user_id, attributes: {name: decoded_token.first['attributes']["name"], email: decoded_token.first['attributes']["email"], location: decoded_token.first['attributes']["location"]}})
    else
      @artist = Artist.new({attributes: {name: decoded_token.first['attributes']["name"], email: decoded_token.first['attributes']["email"], location: decoded_token.first['attributes']["location"], id: decoded_token.first['attributes']["user_id"]}})
    end

    session[:user_id] = user_id
    if @user.attributes.any?(nil)
      redirect_to edit_user_path(@user.id)
    elsif @artist.attributes.any?(nil)
      redirect_to edit_artist_path(@artist.id)
    elsif @user
      redirect_to user_dashboard_path(@user.id)
    elsif @artist
      redirect_to artist_dashboard_path(@artist.id)
    end
  end

  def destroy
    #SessionService.sign_out#(current_user)
    redirect_to root_path
  end

  private
  def invalid_credentials_error
    redirect_to root_path
    flash[:error] = 'Invalid email/password combination'
  end

  def sign_in_params
    params.require(:sign_in).permit(:email, :password, :type)
  end
end
