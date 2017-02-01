class Course < ApplicationRecord

  has_many :exercises, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :students, through: :attendances, source: :user
  
end
