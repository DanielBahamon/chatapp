class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  # GET /users
  def index
    @users = User.all
    message = @users.empty? ? 'No users found' : 'Users found'

    render json: { data: @users, message: message }, status: :ok
  end

  # GET /users/:username
  def show
    render json: { data: @user, message: 'User found' }, status: :ok
  end

  # POST /users
  def create
    @user = User.create!(user_params)
    render json: { data: @user, message: 'User created' }, status: :created, location: @user
  end

  # PATCH/PUT /users/:username
  def update
    if @user.update(user_params)
      render json: { data: @user, message: 'User updated' }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /users/:username
  def destroy
    @user.destroy!
    render json: { message: 'User deleted' }, status: :ok
  end

  private

  def set_user
    @user = User.find_by!(username: params[:username])
  end

  def user_params
    params.permit(:username, :email, :password)
  end

  def record_not_found(error)
    render json: { message: error.message }, status: :not_found
  end

  def record_invalid(error)
    render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
  end
end
