class SessionsController <ApplicationController
  def create
    jwt_token = params[:token]
    
    if jwt_token
      decoded_token = JWT.decode(jwt_token, ENV['JWT_SECRET'], true, {algorithm: 'HS256'})
      if decoded_token.first['attributes']['user_id']
        user_id = decoded_token.first['attributes']['user_id']
        @user = User.new({id: user_id, attributes: {name: decoded_token.first['attributes']["name"], email: decoded_token.first['attributes']["email"], location: decoded_token.first['attributes']["location"], search_radius: decoded_token.first['attributes']["search_radius"]}})
        session[:user_id] = user_id
      end

      if @user.attributes.include?(nil)
        redirect_to edit_user_path(@user.id)
      elsif @user
        redirect_to user_dashboard_path(@user.id)
      end
    else
      response = SessionService.authenticate(sign_in_params)

      return invalid_credentials_error if response.key?(:error)

      if response[:data][:type] == "user"
        user_id = response[:data][:id]
        session[:user_id] = user_id
        redirect_to user_dashboard_path(user_id: user_id)
      else
        artist_id = response[:data][:id]
        session[:artist_id] =  artist_id
        redirect_to artist_dashboard_path(artist_id:  artist_id)
      end
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
