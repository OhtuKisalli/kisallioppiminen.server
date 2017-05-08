Rails.application.routes.draw do

  if Rails.env.production?
    devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }, :skip => :registration
  else
    devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  end

  resources :teachings, only: [:index]
  resources :schedules, only: [:index]
  resources :attendances, only: [:index]
  resources :checkmarks, only: [:index]
  resources :exercises, only: [:index, :show]
  resources :users, only: [:index]
  resources :courses, only: [:index, :show]
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # Backend root
  root 'welcome#index'
  
  # Student - new/update checkmark
  post '/checkmarks' => 'checkmarks#mark', defaults: { format: 'json' }, constraints: {format: 'json'}
  
  # Student – get checkmarks
  get '/students/:sid/courses/:cid/checkmarks' => 'checkmarks#student_checkmarks'
    
  # Scoreboard(s) for teacher
  get '/teachers/:id/scoreboards' => 'scoreboards#scoreboards'
  get '/courses/:id/scoreboard' => 'scoreboards#scoreboard'
  
  # Scoreboard(s) for student
  get '/students/:id/scoreboards' => 'scoreboards#student_scoreboards'
  get '/students/:sid/courses/:cid/scoreboard' => 'scoreboards#student_scoreboard'

  # Teacher – courses
  get '/teachers/:id/courses' => 'courses#mycourses_teacher'
  
  # Student - courses
  get '/students/:id/courses' => 'courses#mycourses_student'

  # Student - leave course
  delete '/students/:sid/courses/:cid' => 'attendances#leave_course', defaults: { format: 'json' }, constraints: {format: 'json'}

  # Student – join course
  post '/courses/join' => 'attendances#newstudent', defaults: { format: 'json' }, constraints: {format: 'json'}

  # Teacher – create course
  post '/courses/newcourse' => 'courses#newcourse', defaults: { format: 'json' }, constraints: {format: 'json'}
  
  # Teacher - add schedule to schedules list
  post '/courses/:id/schedules/new' => 'schedules#new_schedule', defaults: { format: 'json' }, constraints: {format: 'json'}
  
  # Teacher - delete schedule
  delete '/courses/:cid/schedules/:did' => 'schedules#delete_schedule', defaults: { format: 'json' }, constraints: {format: 'json'}
  
  # Teacher - Add / update exercises of schedules created
  post '/courses/:id/schedules/' => 'schedules#update_exercises', defaults: { format: 'json' }, constraints: {format: 'json'}

  # User - get schedules
  get '/courses/:id/schedules/' => 'schedules#get_schedules'

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
  
  ### admin-tools ###
  get '/admins/exerciselists/' => 'admin#sync_exercises_index'
  post '/admins/exerciselists/new' => 'admin#sync_exercises_new'
  delete '/admins/exerciselists/:id' => 'admin#sync_exercises_delete'
  post '/admins/exerciselists/save' => 'admin#sync_exercises_save'
  post '/admins/exerciselists/update' => 'admin#sync_exercises_update'
  get '/admins/courses/' => 'admin#fake_courses_index'
  delete '/admins/courses/:id' => 'admin#fake_courses_delete'
  delete '/admins/users/:id/courses' => 'admin#fake_courses_delete_all'
  post '/admins/users/:id/block' => 'admin#block_user'
  post '/admins/users/:id/unblock' => 'admin#unblock_user'


end
