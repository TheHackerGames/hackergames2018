class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @availability = Availability.new
  end

  def create
    Availability.create!(create_params.merge(user: current_user))
    redirect_to action: :index
  end

  def create_params
    params.require(:availability).permit!.to_h.symbolize_keys
  end

  def index
    @availabilities = Availability.where(user: current_user)
  end
end
