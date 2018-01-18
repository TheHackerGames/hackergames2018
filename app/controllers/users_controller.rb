class UsersController < ApplicationController
  before_action :authenticate_user!

  def profile; end

  def update
    current_user.update!(update_params)
    redirect_to profile_path
  end

  private

  def update_params
    params.require(:user).permit(:name, :avatar_url).to_h.symbolize_keys
  end
end