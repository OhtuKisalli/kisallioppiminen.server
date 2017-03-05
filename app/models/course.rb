require 'date'

class Course < ApplicationRecord

  has_many :exercises, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :students, through: :attendances, source: :user
    
  has_many :teachings, dependent: :destroy
  has_many :teachers, through: :teachings, source: :user
  
  def courseinfo
    h = basic_course_info
    h["name"] = self.name
    return h
  end
  
  def courseinfo_with_coursename
    h = basic_course_info
    h["coursename"] = self.name
    return h
  end
  
  private
    def basic_course_info
      h = {}
      h["id"] = self.id
      h["coursekey"] = self.coursekey
      h["html_id"] = self.html_id
      h["startdate"] = self.startdate.to_s
      h["enddate"] = self.enddate.to_s
      return h
    end
end
