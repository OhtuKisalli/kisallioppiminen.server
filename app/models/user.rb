class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :checkmarks, dependent: :destroy
  has_many :exercises, through: :checkmarks
  
  has_many :attendances, dependent: :destroy
  has_many :courses, through: :attendances

end
