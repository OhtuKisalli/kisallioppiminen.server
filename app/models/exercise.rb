class Exercise < ApplicationRecord

  belongs_to :exerciselist
  has_many :courses, through: :exerciselist
  
end
