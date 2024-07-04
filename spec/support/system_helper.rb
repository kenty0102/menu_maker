module SystemHelper
  def register_user(username, email, password, password_confirmation)
    visit new_user_path
    fill_in "user_name", with: username
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    fill_in "user_password_confirmation", with: password_confirmation
    click_button "登録"
  end
end

RSpec.configure do |config|
  config.include SystemHelper
end
