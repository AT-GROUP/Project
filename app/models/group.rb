class Group < ActiveRecord::Base
  has_many :students
  has_one :timetable, dependent: :destroy
end
