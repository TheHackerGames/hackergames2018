class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @availabilities = Availability.where(user: current_user)
  end

  def new
    start_datetime = current_time = Time.zone.now
    end_datetime = current_time + 1.hour
    @availability = Availability.new(start_datetime: start_datetime, end_datetime: end_datetime)
  end

  def edit
    @availability = Availability.find(params[:id])
  end

  def create
    Availability.create!(availability_params.merge(user: current_user))
    redirect_to action: :index
  end

  def update
    availability = Availability.find(params[:id])
    availability.update!(availability_params)
    redirect_to action: :index
  end

  def search_form; end

  def search
    time = search_params[:time]
    @availabilities = Availability.where('? BETWEEN start_datetime AND end_datetime', time)
  end

  private

  def availability_params
    params.require(:availability).permit!.to_h.symbolize_keys
  end

  def search_params
    params.permit!.to_h.symbolize_keys
  end
end
