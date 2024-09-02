class ProfilesController < ApplicationController
  before_action :require_login
  before_action :set_user

  def show; end

  def edit_username; end

  def update_username
    update_user_attribute(:username, username_params)
  end

  def edit_email; end

  def update_email
    update_user_attribute(:email, email_params)
  end

  def edit_password; end

  def update_password
    if missing_password_fields?
      add_password_errors
      render_failure(:edit_password)
    elsif @user.valid_password?(password_params[:current_password])
      if password_mismatch?
        add_password_mismatch_error
        render_failure(:edit_password)
      elsif @user.update(password_params.except(:current_password))
        redirect_to profile_path, success: t('.success')
      else
        render_failure(:edit_password)
      end
    else
      add_invalid_current_password_error
      render_failure(:edit_password)
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def username_params
    params.require(:user).permit(:name)
  end

  def email_params
    params.require(:user).permit(:email)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def update_user_attribute(attribute, params)
    if @user.update(params)
      redirect_to profile_path, success: t('.success')
    else
      render_failure("edit_#{attribute}")
    end
  end

  def missing_password_fields?
    password_params.values.any?(&:blank?)
  end

  def password_mismatch?
    password_params[:password] != password_params[:password_confirmation]
  end

  def add_password_errors
    @user.errors.add(:current_password, "を入力してください") if password_params[:current_password].blank?
    @user.errors.add(:new_password, "を入力してください") if password_params[:password].blank?
    @user.errors.add(:new_password_confirmation, "を入力してください") if password_params[:password_confirmation].blank?
  end

  def add_password_mismatch_error
    @user.errors.add(:new_password_confirmation, "と新しいパスワードの入力が一致しません")
  end

  def add_invalid_current_password_error
    @user.errors.add(:current_password, "は正しくありません")
  end

  def render_failure(action)
    flash.now[:danger] = t('.failure')
    render action, status: :unprocessable_entity
  end
end
