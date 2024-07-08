class ProfilesController < ApplicationController
  before_action :require_login
  before_action :set_user, only: %i[show edit_username update_username edit_email]

  def show; end

  def edit_username; end

  def update_username
    if @user.update(username_params)
      redirect_to profile_path, success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render :edit_username, status: :unprocessable_entity
    end
  end

  def edit_email; end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def username_params
    params.require(:user).permit(:name)
  end
end
