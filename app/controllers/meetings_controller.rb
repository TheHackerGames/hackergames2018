class MeetingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @meetings = current_user.meetings
  end

  def show
    @meeting = Meeting.find(params[:id])
  end
end
