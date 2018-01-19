class Meeting < ApplicationRecord
  belongs_to :availability
  belongs_to :user

  def user_type(current_user)
    return :offering if availability.user.id == current_user.id
    return :need if user.id == current_user.id
    :invalid
  end
end
