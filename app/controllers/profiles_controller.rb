class ProfilesController < ApplicationController
  before_action :require_login
  before_action :set_user, only: %i[show edit_username]

  def show; end

  def edit_username; end

  private

  def set_user
    @user = User.find(current_user.id)
  end
end
