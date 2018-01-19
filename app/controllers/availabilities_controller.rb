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

  def edit; end

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
    @date = search_params[:date]
    @time = search_params[:time]
    @latitude = search_params[:latitude].to_f
    @longitude = search_params[:longitude].to_f
    @within = search_params[:within].to_f

    @availabilities = Availability.where("? BETWEEN (start_datetime - interval '1h') AND (end_datetime + interval '1h')", DateTime.parse("#{@date} #{@time}"))
                                  .near([@latitude, @longitude], @within)

    @availabilities_json = @availabilities.map.with_index { |a, i| a.attributes.merge('label' => i.to_s) }
  end

  def request_meeting
    meeting = Meeting.create!(user: current_user, availability: @availability)
    redirect_to meeting_path(meeting), notice: 'Request sent'
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
