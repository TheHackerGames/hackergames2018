class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_availability, only: %i[edit update request_meeting]

  def index
    @availabilities = Availability.where(user: current_user)
  end

  def new
    start_datetime = current_time = Time.zone.now
    end_datetime = current_time + 1.hour
    @availability = Availability.new(start_datetime: start_datetime, end_datetime: end_datetime)
  end

  def edit
  end

  def create
    Availability.create!(availability_params.merge(user: current_user))
    redirect_to action: :index
  end

  def update
    @availability.update!(availability_params)
    redirect_to action: :index
  end

  def search_form; end

  def search
    time = search_params[:time]
    @availabilities = Availability.where('? BETWEEN start_datetime AND end_datetime', time)
  end

  def request_meeting
    Meeting.create!(user: current_user, availability: @availability)
    redirect_to meetings_path, notice: 'Request sent'
  end

  private

  def availability_params
    params.require(:availability).permit!.to_h.symbolize_keys
  end

  def search_params
    params.permit!.to_h.symbolize_keys
  end

  def find_availability
    @availability = Availability.find(params[:id])
  end
end
