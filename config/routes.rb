Rails.application.routes.draw 
  concern :cancelable do |options|
    resource :cancellation, options.merge(only: :create)
  end

  concern :confirmable do
    post "confirm", on: :collection
  end

  resource :orders, concerns: :confirmable, except: %i[edit update destroy]
    concerns :cancelable, module "oreder"
end
