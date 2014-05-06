Rails.application.config.middleware.use OmniAuth::Builder do
  provider :fitbit, ENV["FIT_BIT_CONSUMER_KEY"], ENV["FIT_BIT_CONSUMER_SECRET"] 
end
