class OauthsController < ApplicationController
  require 'googleauth/id_tokens/verifier'
  skip_before_action :require_login

  protect_from_forgery except: :callback
  before_action :verify_g_csrf_token

  def callback
    payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: ENV.fetch('GOOGLE_CLIENT_ID'))
    user = User.find_or_initialize_by(email: payload['email']) do |new_user|
      new_user.name = payload['name']
      new_user.skip_password_validation = true
    end

    if user.save
      session[:user_id] = user.id
      redirect_to root_path, success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def verify_g_csrf_token
    redirect_to root_path, danger: t('.unauthorized') if cookies["g_csrf_token"].blank? || params[:g_csrf_token].blank? || cookies["g_csrf_token"] != params[:g_csrf_token]
  end
end
