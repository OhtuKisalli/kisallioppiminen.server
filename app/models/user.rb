class User < ApplicationRecord

  has_many :checkmarks, dependent: :destroy
  has_many :exercises, through: :checkmarks
  
  has_many :attendances, dependent: :destroy
  has_many :courses, through: :attendances

end
