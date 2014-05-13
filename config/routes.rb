FitBitIntegration::Application.routes.draw do
  
  get 'sleep_logs/index'
  post 'sleep_logs/show'

  get 'authorization/auth_fitbit'
  get 'auth/:provider/callback', to: 'sessions#create'

end
