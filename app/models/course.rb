class Course < ApplicationRecord

  has_many :exercises, dependent: :destroy
  
end
