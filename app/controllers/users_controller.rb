class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create, :index]

  def index
    render json: {
      response: 'Welcome.'
    }
  end

  def create
    user = User.create(user_params)
    if user.valid?
        payload = {user_id: user.id}
        token = encode_token(payload)
        puts token
        render json: { user: user, jwt: token, status: 'created' }
    else
        render json: {errors: user.errors.full_messages}
    end
  end

  private

  def user_params
    params.permit(:username, :password)
  end
end
