Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :grid_orders do
      collection do
        put "reorder"
      end
    end
  end
end
