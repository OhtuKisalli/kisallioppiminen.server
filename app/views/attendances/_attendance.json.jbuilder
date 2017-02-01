json.extract! attendance, :id, :user_id, :course_id, :created_at, :updated_at
json.url attendance_url(attendance, format: :json)