module Alipay
  class Admin::AppsController < Admin::BaseController
    before_action :set_app, only: [:show, :edit, :update, :destroy, :actions, :edit_cert, :update_cert]
    before_action :set_new_app, only: [:new, :create]

    def index
      q_params = {}
      q_params.merge! default_params

      @apps = App.default_where(q_params)
    end

    def edit_cert
    end

    def update_cert
      @app.private_rsa = params[:cert].read if params[:cert].respond_to?(:read)
      @app.save
    end

    private
    def set_app
      @app = App.find params[:id]
    end

    def set_new_app
      @app = App.new(app_params)
    end

    def app_params
      p = params.fetch(:app, {}).permit(
        :name,
        :appid,
        :private_rsa
      )
      p.merge! default_form_params
    end
  end
end
