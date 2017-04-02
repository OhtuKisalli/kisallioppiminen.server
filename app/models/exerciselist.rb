class Exerciselist < ApplicationRecord

  has_many :exercises, dependent: :destroy
  
end
