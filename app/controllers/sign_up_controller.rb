class SignUpController < ApplicationController
  before_action :log_current_state
  after_action :log_current_state

  def type_step
    new_state
  end

  def meet_type_step
    merge_state(user_type: params[:user_type]) if params.include? :user_type
  end

  def name_step
    merge_state(meet_user_type: params[:meet_user_type]) if params.include? :meet_user_type
  end

  def email_step
    merge_state(first_name: params[:first_name]) if params.include? :first_name
    merge_state(last_name: params[:last_name]) if params.include? :last_name
  end

  def photo_step
    merge_state(email: params[:email]) if params.include? :email

    @image = Image.new
  end

  def upload_photo
    image = Image.create!(file: params[:image][:file])
    merge_state(image_id: image.id)
    redirect_to action: :date_step
  end

  def location

  end

  def shop_step
  end

  def date_step
  end

  def time_step
  end

  def final_step
    user = User.create!(
      name: current_state[:name],
      avatar_url: current_state[:avatar_url],
      image_id: current_state[:image_id],
      email: current_state[:email],
      password: current_state[:password],
    )
    Availability.create!(
      user: user,
      name: params[:shop_name],
      address: params[:shop_address],
      latitude: params[:latitude],
      longitude: params[:longitude],
      gmaps_place_id: params[:gmaps_place_id],
      start_datetime: params[:start_datetime],
      end_datetime: params[:end_datetime],
    )
  end

  private

  def current_state
    JSON.parse(cookies.encrypted[:state] || '{}').symbolize_keys
  end
  helper_method :current_state

  def new_state(state = {})
    cookies.encrypted[:state] = state.to_json
  end

  def merge_state(state)
    new_state(current_state.merge(state))
  end

  def log_current_state
    logger.info "  Current state: #{current_state}"
  end
end
