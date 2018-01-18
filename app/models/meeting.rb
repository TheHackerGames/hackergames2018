class Meeting < ApplicationRecord
  belongs_to :availability
  belongs_to :user

  def meeting_with!(other_user)
    raise if [user, availability.user].include? other_user

    if user == other_user
      availability.user
    else
      user
    end
  end
end
