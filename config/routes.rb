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
  post '/checkmarks/mycheckmarks' => 'checkmarks#vanha', defaults: { format: 'json' }, constraints: {format: 'json'}
  # API
  post '/test_students/create' =>  'test_students#create_new_from_form'

  #Student – I can see from an exercise if I have done it
  get '/students/:sid/courses/:cid/checkmarks' => 'checkmarks#student_checkmarks'
  #Student – I can see from an exercise if I have done it
  get '/courses/:cid/mycheckmarks' => 'checkmarks#mycheckmarks'

  #hardcoded
  get '/course/:id/checkmarks' => 'courses#get_checkmarks'
  #scoreboard without current_user
  get '/courses/:id/checkmarks' => 'courses#sboard'
  #scoreboards for teacher: current_user
  get '/courses/scoreboards' => 'courses#scoreboards'
  get '/courses/:id/scoreboard' => 'courses#scoreboard'  

  #Teacher – I can see a listing of my courses
  get '/teachers/mycourses' => 'courses#mycourses_teacher'

  #Student – I can join a specific course using a coursekeys
  post '/courses/join' => 'attendances#newstudent'

  # Check if is logged
  get '/user/is_logged' => 'users#is_user_signed_in'

  resources :courses

end
