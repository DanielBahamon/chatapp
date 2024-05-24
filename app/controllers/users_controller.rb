class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    if @users.empty?
      render json: { error: 'No users found' }, status: :ok
    else
      render json: { data: @users, message: 'Users found' }, status: :ok
    end
  end

  # GET /users/username
  def show
    if @user.nil?
      render json: { error: 'User not found' }, status: :not_found
    else
      render json: @user
    end
  end

  # POST /users
  def create
    @user = User.create!(user_params)

    if @user.save
      render json: { data: @user, message: "User created" }, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/username
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/username
  def destroy
    if @user
      @user.destroy!
      render json: { message: 'User deleted' }, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(username: params[:username])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:username, :email, :password)
    end
end
