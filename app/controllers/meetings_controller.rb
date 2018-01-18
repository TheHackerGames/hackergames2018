class MeetingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @meetings = Meeting.where(availability: Availability.where(user: current_user))
      .or(Meeting.where(user: current_user))
  end

  def create
    Meeting.create!(create_params.merge(user: current_user))
    redirect_to action: :index
  end

  private

  def create_params
    params.require(:meeting).permit!.to_h.symbolize_keys
  end
end
