class Exercise < ApplicationRecord

  belongs_to :course
  has_many :checkmarks, dependent: :destroy
  has_many :students, through: :checkmarks, source: :user

end
