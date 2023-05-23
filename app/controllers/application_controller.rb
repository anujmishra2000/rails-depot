class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  before_action :authorize
  before_action :check_for_inactivity, if: :logged_in?
  before_action :get_client_ip
  before_action :update_hit_count
  around_action :attach_time_in_header

  helper_method :current_user

  protected

    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end

    def logged_in?
      current_user.present?
    end

    def check_for_inactivity
      if current_user.last_active && ((Time.current - current_user.last_active.to_time) > 5.minutes)
        reset_session
        redirect_to login_url, notice: 'You were inactive for a long time. Please log in again to activate your session.'
      else
        current_user.update(last_active: Time.current)
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
      PAGE_PATH_REGEX =~ request.path
      page_path = $1
      @hit_count = PageHitCount.find_or_create_by!(path: page_path).increment!(:hit_count).hit_count
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
