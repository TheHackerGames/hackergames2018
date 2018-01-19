class Image < ApplicationRecord
  has_attached_file :file

  validates :file, presence: true
  validates_attachment :file,
    content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
end
