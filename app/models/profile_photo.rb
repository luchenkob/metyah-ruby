class ProfilePhoto < ApplicationRecord
  belongs_to :user

  has_uploadcare_file :url
end
