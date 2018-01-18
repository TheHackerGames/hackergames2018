class SignUpController < ApplicationController
  def type_step
    new_state
  end

  def name_step
    merge_state(type: params[:type]) if params.include? :type
  end

  def photo_step
    merge_state(name: params[:name]) if params.include? :name
  end

  def shop_step
    merge_state(avatar_url: params[:avatar_url]) if params.include? :avatar_url
  end

  def date_step
  end

  def time_step
  end

  def final_step
    user = User.create!(
      name: current_state[:name],
      avatar_url: current_state[:avatar_url],
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
    cookies[:state] || {}
  end
  helper_method :current_state

  def new_state
    cookies[:state] = {}.to_json
  end

  def merge_state(state)
    new_state(current_state.merge(state))
  end
end
