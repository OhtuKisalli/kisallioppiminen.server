Rails.application.routes.draw do
  resources :teachings
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :schedules
  resources :deadlines
  resources :attendances
  resources :checkmarks, only: [:index, :destroy]
  resources :exercises
  resources :users
  resources :test_students
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  
  # new/update checkmark, JSON only
  post '/checkmarks' => 'checkmarks#mark', defaults: { format: 'json' }, constraints: {format: 'json'}
  
  #Student – I can see from an exercise if I have done it
  get '/students/:sid/courses/:cid/checkmarks' => 'checkmarks#student_checkmarks'
    
  #scoreboards for teacher: current_user
  get '/teachers/:id/scoreboards' => 'courses#scoreboards'
  get '/courses/:id/scoreboard' => 'courses#scoreboard'  

  #Teacher – I can see a listing of my courses
  get '/teachers/mycourses' => 'courses#mycourses_teacher'
  
  #courses for student
  get '/students/:id/courses' => 'courses#mycourses_student'

  #Student – I can join a specific course using a coursekeys
  post '/courses/join' => 'attendances#newstudent', defaults: { format: 'json' }, constraints: {format: 'json'}

  #Teacher – I can create coursekeys for students to join my course
  post '/courses/newcourse' => 'courses#newcourse', defaults: { format: 'json' }, constraints: {format: 'json'}

  # Session
  get '/user/is_logged' => 'users#is_user_signed_in'
  get '/user/get_session_user' => 'users#get_session_user'

  # Change archived
  post 'students/:sid/courses/:cid/toggle_archived' => 'attendances#toggle_archived', defaults: { format: 'json' }, constraints: {format: 'json'}
  post 'teachers/:sid/courses/:cid/toggle_archived' => 'teachings#toggle_archived', defaults: { format: 'json' }, constraints: {format: 'json'}
  
  # Updating course
  put 'courses/:id' => 'courses#update', defaults: { format: 'json' }, constraints: {format: 'json'}
  
  # TESTAILUA VARTEN
  post '/test/json' => 'tests#jsontest', defaults: { format: 'json' }, constraints: {format: 'json'}
  get '/test/idtest' => 'tests#idtest'
  post '/test/idtest2' => 'tests#idtest2', defaults: { format: 'json' }, constraints: {format: 'json'}

  resources :courses

end
