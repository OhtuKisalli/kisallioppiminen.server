class Exerciselist < ApplicationRecord

  has_many :courses
  has_many :exercises, dependent: :destroy
  
end
