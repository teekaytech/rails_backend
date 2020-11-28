class AuthController < ApplicationController
  skip_before_action :require_login, only: [:login, :auto_login, :logout]
  def login
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
        payload = {user_id: user.id}
        token = encode_token(payload)
        render json: {user: user, jwt: token, success: "Welcome back, #{user.username}", status: 'logged_in'}
    else
        render json: {failure: "Log in failed! Username or password invalid!"}
    end
  end

  def auto_login
    if session_user
      render json: { status: 'logged_in', user: session_user }
    else
      render json: {message: "No user is currently logged in"}
    end
  end

  def logout
    reset_session
    render json: {
      logged_out: true,
      status: 200
    }
  end

  def user_is_authed
    render json: {message: "You are authorized"}
  end
end
