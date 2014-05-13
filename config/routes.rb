FitBitIntegration::Application.routes.draw do
  
  get 'sleep_logs/index'
  get 'sleep_logs/:username/:date', to: 'sleep_logs#get_by_date'
  post 'sleep_logs/show'

  get 'authorization/auth_fitbit'
  get 'auth/:provider/callback', to: 'sessions#create'

end
