class MeetingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @meetings = Meeting.where(availability: Availability.where(user: current_user))
      .or(Meeting.where(user: current_user))
  end
end
