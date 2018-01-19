class MeetingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @meetings = current_user.meetings.map{|m| m.present_for(current_user)}
  end

  def show
    meeting = Meeting.find(params[:id])
    head :not_found unless meeting.user_id == current_user.id || meeting.availability.user_id == current_user.id

    @meeting = meeting.present_for(current_user)
  end
end
