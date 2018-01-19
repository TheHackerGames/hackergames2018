class SignUpController < ApplicationController
  before_action :log_current_state
  after_action :log_current_state

  def type_step
    return redirect_to action: :location_step if signed_in?

    new_state
  end

  def meet_type_step
    merge_state(user_type: params[:user_type]) if params.include? :user_type

    unless current_state.include? :user_type
      flash[:alert] = 'Missing user type'
      return redirect_to action: :type_step
    end

    if current_state[:user_type] == 'civilian'
      redirect_to action: :name_step
    end
  end

  def name_step
    merge_state(meet_user_type: params[:meet_user_type]) if params.include? :meet_user_type
  end

  def photo_step
    merge_state(first_name: params[:first_name]) if params.include? :first_name
    merge_state(last_name: params[:last_name]) if params.include? :last_name

    @name = current_state[:first_name]
    @image = Image.new
  end

  def upload_photo
    image = Image.create(file: params.dig(:image, :file))
    if image.persisted?
      merge_state(image_id: image.id)
      redirect_to action: :nice_photo_step
    else
      logger.warn "  Image errors: #{image.errors.full_messages}"
      flash[:alert] = 'Invalid file'
      redirect_to action: :photo_step
    end
  end

  def nice_photo_step
    @image = Image.find(current_state[:image_id])
  end

  def location_step; end

  def coffeeshop_step
    merge_state(
      location_name: params[:name],
      location_address: params[:address],
      location_latitude: params[:latitude].to_f,
      location_longitude: params[:longitude].to_f,
      location_gmaps_place_id: params[:gmaps_place_id]
    )
  end

  def date_step
    merge_state(
      shop_name: params[:name],
      shop_address: params[:address],
      latitude: params[:latitude],
      longitude: params[:longitude],
      gmaps_place_id: params[:gmaps_place_id],
    )
  end

  def time_step
    if params.include? :date
      date =
        begin
          Date.parse(params[:date])
        rescue
          flash[:alert] = 'Invalid date'
          return redirect_to action: :date_step
        end

      merge_state(date: date)
    end

    unless current_state.include? :date
      flash[:alert] = 'Missing date'
      return redirect_to action: :date_step
    end
  end

  def email_step
  end

  def sign_up
    unless params.include? :email
      flash[:alert] = 'Missing email'
      return redirect_to action: :email_step
    end

    user = User.create(
      name: current_state[:first_name],
      email: params[:email],
      password: 'carwow',
      image_id: current_state[:image_id],
    )

    unless user.persisted?
      logger.warn "  User errors: #{user.errors.full_messages}"
      flash[:alert] = "Failed to create account 😢 #{user.errors.full_messages.join('<br>')}"
      return redirect_to action: :email_step
    end

    sign_in user

    if current_state[:user_type] == 'civilian'
      create_availability
    else
      redirect_to search_form_availabilities_path
    end
  end

  def create_availability
    if params.include? :start_datetime
      merge_state(start_datetime: DateTime.parse("#{current_state[:date]} #{params[:start_time]}"))
    end

    if params.include? :end_datetime
      merge_state(end_datetime: DateTime.parse("#{current_state[:date]} #{params[:end_time]}"))
    end

    return redirect_to action: :email_step unless signed_in?

    availability = Availability.create(
      user: current_user,
      name: current_state[:shop_name],
      address: current_state[:shop_address],
      latitude: current_state[:latitude],
      longitude: current_state[:longitude],
      gmaps_place_id: current_state[:gmaps_place_id],
      start_datetime: current_state[:start_datetime],
      end_datetime: current_state[:end_datetime],
    )

    unless availability.persisted?
      logger.warn "  Availability errors: #{availability.errors.full_messages}"
      flash[:alert] = "Failed to setup date and place 😢 #{availability.errors.full_messages.join('<br>')}"
      return redirect_to action: :time_step
    end

    redirect_to profile_path
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

  def skip_sign_up_steps
    redirect_to action: :location_step
  end

  def start_from_beginning
    redirect_to action: :type_step
  end
end
