module SystemHelper
  def register_user(username, email, password, password_confirmation)
    visit new_user_path
    fill_in 'user_name', with: username
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password_confirmation
    click_button '登録'
  end

  def login(user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'password'
    click_button 'ログイン'
  end

  def new_password_confirmation
    fill_in 'user_current_password', with: 'password'
    fill_in 'user_password', with: 'newpassword'
    fill_in 'user_password_confirmation', with: 'newpassword'
    click_button '変更する'
    click_on 'ログアウト'
    click_link 'ログイン'
  end

  def menu_update(first_recipe)
    visit edit_menu_path(menu)
    fill_in 'menu_title', with: 'Updated Menu'
    find("input[type='checkbox'][value='#{first_recipe.id}']").uncheck
  end
end

RSpec.configure do |config|
  config.include SystemHelper
end
