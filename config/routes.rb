Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    namespace :alipay, defaults: { business: 'alipay' } do
      namespace :admin, defaults: { namespace: 'admin' } do
        
      end
    end
  end
end
