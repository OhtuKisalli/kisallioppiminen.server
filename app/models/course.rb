class Course < ApplicationRecord

  has_many :exercises, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :students, through: :attendances, source: :user
    
  has_many :teachings, dependent: :destroy
  has_many :teachers, through: :teachings, source: :user
  
end
