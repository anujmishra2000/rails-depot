class AdminBaseController < ApplicationController
  before_action :ensure_user_is_admin

  def ensure_user_is_admin
    redirect_to store_index_path, notice: "You don't have privilege to access this section" unless current_user.admin?
  end
end
