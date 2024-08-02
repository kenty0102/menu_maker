class ApplicationController < ActionController::Base
  before_action :require_login
  skip_before_action :require_login, if: -> { request.path.start_with?('/pages/') }
  add_flash_types :success, :danger

  private

  def not_authenticated
    redirect_to root_path
  end
end
