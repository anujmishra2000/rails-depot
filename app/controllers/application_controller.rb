class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  before_action :authorize
  before_action :check_for_inactivity
  before_action :get_client_ip
  before_action :update_hit_count
  around_action :attach_time_in_header

  helper_method :current_user

  protected

    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end

    def check_for_inactivity
      if session[:last_active] && ((Time.current - session[:last_active].to_time) > 5.minutes)
        reset_session
        redirect_to login_url, notice: 'You were inactive for a long time. Please log in again to activate your session.'
      else
        session[:last_active] = Time.current
      end
    end

    def get_client_ip
      @client_ip = request.ip
    end

    def attach_time_in_header
      start_timer = Time.current
      yield
      response.header['x-responded-in'] = (Time.current - start_timer) * 1000
    end

    def update_hit_count
      @@hit_count ||= 0
      @@hit_count += 1
      @hit_count = @@hit_count
    end

    def authorize
      if request.format == Mime[:html]
        unless User.find_by(id: session[:user_id])
          redirect_to login_url, notice: "Please log in"
        end
      else
        authenticate_or_request_with_http_basic do |username, password|
          user = User.find_by(name: username)
          user && user.authenticate(password)
        end
      end
    end

    def is_admin?
      redirect_to store_index_path, notice: "You don't have privilege to access this section" unless current_user.admin?
    end

    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.map(&:to_s).include?(params[:locale])
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end
end
