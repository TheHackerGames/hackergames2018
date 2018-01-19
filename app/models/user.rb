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
    (Meeting.joins(:availability).where(availabilities: { user_id: id }) + Meeting.where(user_id: id)).flatten
  end

  def avatar_url
    @avatar_url || image&.file&.url
  end
end
