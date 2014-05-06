FitBitIntegration::Application.routes.draw do
  get 'sessions/create'

  get 'session/create'

  get 'auth/:provider/callback', to: 'sessions#create'

end
