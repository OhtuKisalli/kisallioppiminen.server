class User < ApplicationRecord

  has_many :checkmarks, dependent: :destroy
  has_many :exercises, through: :checkmarks

end
