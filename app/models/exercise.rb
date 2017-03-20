class Exercise < ApplicationRecord

  belongs_to :course
  
  has_many :schedules, dependent: :destroy
  has_many :deadlines, through: :schedules

end
