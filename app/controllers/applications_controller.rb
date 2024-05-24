class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application, only: %i[ show update destroy ]

  # GET /applications
  def index
    @applications = Application.all

    if @applications.empty?
      render json: { message: 'No applications found' }, status: :ok
    else
      render json: { data: @applications, message: 'Applications found' }, status: :ok
    end
  end

  # GET /applications/token
  def show
    render json: { data: @application, message: 'Application found' }, status: :ok
  end

  # POST /applications
  def create
    while Application.find_by(token: random_hash = Digest::SHA256.hexdigest(Time.now.to_s)[0..9])
    end
    @application = Application.new(application_params.merge(token: random_hash))

    if @application.save
      render json: { data: @application, message: "Application created" }, status: :created, location: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/token
  def update
    if @application.update(application_params)
      render json: { data: @application, message: "Application updated" }, status: :ok
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/token
  def destroy
    @application.destroy!
    render json: { message: "Application deleted" }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by(token: params[:token])

      if @application.nil?
        return render json: { message: "Application not found" }, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.require(:application).permit(:name)
    end
end
