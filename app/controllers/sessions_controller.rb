class SessionsController <ApplicationController
  def destroy
    # request BE to delete session here
    redirect_to root_path
  end
end