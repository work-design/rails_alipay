Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    namespace :alipay, defaults: { business: 'alipay' } do
      namespace :admin, defaults: { namespace: 'admin' } do
        root 'home#index'
        resources :apps do
          member do
            post :edit_cert
            post :update_cert
          end
        end
      end
    end
  end
end
