class MenusController < ApplicationController
  before_action :require_login

  def new
    @menu = Menu.new
    @recipes = current_user.recipes
  end
end
