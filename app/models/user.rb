class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :image, optional: true

  def offering_help?
    true
  end

  def meetings
    if offering_help?
      Meeting.joins(:availability).where(availabilities: { user_id: id })
    else
      Meeting.where(user_id: id)
    end
  end
end
