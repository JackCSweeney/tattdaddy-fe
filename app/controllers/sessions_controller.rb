class SessionsController <ApplicationController
  def create
    jwt_token = params[:token] # Extract token from query parameters
    
    require 'pry'; binding.pry
    # Validate the token and extract user information
    decoded_token = JWT.decode(jwt_token, Rails.application.credentials.jwt_secret_key, true, algorithm: 'HS256')
    user_id = decoded_token.first['user_id']
    # Here, you can extract other user information from the token if needed
    
    # Log in the user
    require 'pry'; binding.pry
    session[:user_id] = user_id

    # response = SessionService.authenticate(sign_in_params)
    # return invalid_credentials_error if response.key?(:error)

    # if response[:data][:type] == "user"
    #   user_id = response[:data][:id]
    #   session[:user_id] = user_id
    #   redirect_to user_dashboard_path(user_id: user_id)
    # else
    #   artist_id = response[:data][:id]
    #   session[:artist_id] =  artist_id
    #   redirect_to artist_dashboard_path(artist_id:  artist_id)
    # end
  end

  # def google_oauth2
  #   require 'pry'; binding.pry
  #   redirect_to "/auth/google_oauth2/callback" # Redirect to Google's authorization URL
  # end

  # def google_oauth2_callback
  #   require 'pry'; binding.pry
  #   # Handle Google OAuth callback
  #   authorization_code = params[:code]
    
  #   # Make a POST request to your backend API to exchange authorization code for access token
  #   response = Faraday.post("http://localhost3000.com/auth/google_oauth2/callback", { code: authorization_code })
    
  #    # Handle response from backend
  #    if response.status == 200
  #     # Successful authentication
  #     session[:access_token] = JSON.parse(response.body)['access_token'] # Store access token in session
  #     redirect_to dashboard_path # Redirect to dashboard
  #   else
  #     # Handle authentication failure
  #     redirect_to root_path, alert: "Authentication failed"
  #   end
  # end

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
