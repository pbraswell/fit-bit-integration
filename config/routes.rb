FitBitIntegration::Application.routes.draw do
  
  get 'sleep_logs/index'
  get 'sleep_logs/:username/:date', to: 'sleep_logs#get_by_date'
  post 'sleep_logs/show'

  get 'authorization/auth_fitbit'
  get 'authorization/is_linked/:id', to: 'authorization#is_linked'
  get 'auth/:provider/callback', to: 'sessions#create'

end
