class Meeting < ApplicationRecord
  belongs_to :availability
  belongs_to :user

  def user_type(current_user)
    return :offering if availability.user.id == current_user.id
    return :need if user.id == current_user.id
    :invalid
  end

  def present_for(current_user)
    hash = {
      id: id,
      where: availability.name,
      when: availability.start_datetime
    }

    hash[:who] = if user_type(current_user) == :offering
                   user
                 else
                   availability.user
                 end

    hash
  end
end
