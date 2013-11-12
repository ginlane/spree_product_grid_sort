Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :classifications do
      collection do
        put "reorder"
      end
    end
  end
end
