FitBitIntegration::Application.routes.draw do
  
  get 'authorization/auth_fitbit'
  get 'auth/:provider/callback', to: 'sessions#create'

end
