Rails.application.routes.draw do
  resources :teachings, only: [:index]
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :schedules, only: [:index]
  resources :deadlines, only: [:index, :show]
  resources :attendances, only: [:index]
  resources :checkmarks, only: [:index]
  resources :exercises, only: [:index, :show]
  resources :users, only: [:index]
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  
  # Student - new/update checkmark
  post '/checkmarks' => 'checkmarks#mark', defaults: { format: 'json' }, constraints: {format: 'json'}
  
  # Student – I can see from an exercise if I have done it
  get '/students/:sid/courses/:cid/checkmarks' => 'checkmarks#student_checkmarks'
    
  # Scoreboard(s) for teacher
  get '/teachers/:id/scoreboards' => 'scoreboards#scoreboards'
  get '/courses/:id/scoreboard' => 'scoreboards#scoreboard'
  
  # Scoreboard(s) for student
  get '/students/:id/scoreboards' => 'scoreboards#student_scoreboards'
  get '/students/:sid/courses/:cid/scoreboard' => 'scoreboards#student_scoreboard'

  # Teacher – I can see a listing of my courses
  get '/teachers/:id/courses' => 'courses#mycourses_teacher'
  
  # Courses for student
  get '/students/:id/courses' => 'courses#mycourses_student'

  #Student – I can join a specific course using a coursekeys
  post '/courses/join' => 'attendances#newstudent', defaults: { format: 'json' }, constraints: {format: 'json'}

  # Teacher – I can create coursekeys for students to join my course
  post '/courses/newcourse' => 'courses#newcourse', defaults: { format: 'json' }, constraints: {format: 'json'}
  
  # Teacher - create schedule
  post '/courses/:id/deadlines/new' => 'deadlines#newdeadline', defaults: { format: 'json' }, constraints: {format: 'json'}
  
  # Teacher - delete schedule
  delete '/courses/:cid/deadlines/:did' => 'deadlines#deletedeadline', defaults: { format: 'json' }, constraints: {format: 'json'}

  # Session
  get '/user/is_logged' => 'users#is_user_signed_in'
  get '/user/get_session_user' => 'users#get_session_user'

  # Change archived
  post 'students/:sid/courses/:cid/toggle_archived' => 'attendances#toggle_archived', defaults: { format: 'json' }, constraints: {format: 'json'}
  post 'teachers/:sid/courses/:cid/toggle_archived' => 'teachings#toggle_archived', defaults: { format: 'json' }, constraints: {format: 'json'}
  
  # Exercise statistics of course
  get '/courses/:id/exercises/statistics' => 'courses#exercise_stats'
  
  # Update course
  put 'courses/:id' => 'courses#update', defaults: { format: 'json' }, constraints: {format: 'json'}
    
  resources :courses, only: [:index, :show]

end
