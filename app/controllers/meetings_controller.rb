class MeetingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @meetings = current_user.meetings
  end

  def show
    @meeting = Meeting.find(params[:id])
    return :not_found unless @meeting.user_id == current_user.id || @meeting.availability.user_id == current_user.id
  end
end
