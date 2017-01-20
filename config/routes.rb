Rails.application.routes.draw do
  resources :test_students
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  # API
  post '/test_students/create' =>  'test_students#create_new_from_form'

end