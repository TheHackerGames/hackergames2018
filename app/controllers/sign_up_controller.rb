class SignUpController < ApplicationController
  before_action :log_current_state
  after_action :log_current_state

  SIGN_UP_STEPS = %i[type_step meet_type_step name_step email_step sign_up]
  before_action :skip_sign_up_steps, if: :signed_in?, only: SIGN_UP_STEPS
  before_action :start_from_beginning, unless: :signed_in?, except: SIGN_UP_STEPS

  def type_step
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

  def email_step
    merge_state(first_name: params[:first_name]) if params.include? :first_name
    merge_state(last_name: params[:last_name]) if params.include? :last_name

    unless current_state.include? :first_name
      flash[:alert] = 'Missing name'
      return redirect_to action: :name_step
    end
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
    )

    unless user.persisted?
      logger.warn "  User errors: #{user.errors.full_messages}"
      flash[:alert] = "Failed to create account 😢 #{user.errors.full_messages.join('<br>')}"
      return redirect_to action: :email_step
    end

    sign_in user

    redirect_to action: :photo_step
  end

  def photo_step
    @image = Image.new
  end

  def upload_photo
    image = Image.create(file: params.dig(:image, :file))
    if image.persisted? && current_user.update(image: image)
      redirect_to action: :location_step
    else
      logger.warn "  Image errors: #{image.errors.full_messages}"
      logger.warn "  User errors: #{current_user.errors.full_messages}"
      flash[:alert] = 'Invalid file'
      redirect_to action: :photo_step
    end
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

  def create_availability
    start_datetime = DateTime.parse "#{current_state[:date]} #{params[:start_time]}"
    end_datetime = DateTime.parse "#{current_state[:date]} #{params[:end_time]}"

    @availability = Availability.create!(
      user: current_user,
      name: current_state[:shop_name],
      address: current_state[:shop_address],
      latitude: current_state[:latitude],
      longitude: current_state[:longitude],
      gmaps_place_id: current_state[:gmaps_place_id],
      start_datetime: start_datetime,
      end_datetime: end_datetime,
    )

    redirect_to action: :final_step
  end

  def final_step
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
