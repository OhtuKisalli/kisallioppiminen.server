class Deadline < ApplicationRecord

  has_many :schedules, dependent: :destroy
  has_many :exercises, through: :schedules

end
