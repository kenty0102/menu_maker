RSpec.describe "ユーザー登録機能", type: :system do
  it "ユーザー登録ページに正しいタイトルが表示されている" do
    visit new_user_path
    expect(page).to have_title "新規登録 | Menu Maker"
  end

  context "when 正しい情報が入力された場合" do
    it "登録後に自動でログインすること" do
      register_user(Faker::Name.name, Faker::Internet.email, "password", "password")
      expect(page).to have_link("ログアウト")
    end

    it "登録後にトップページへ遷移すること" do
      register_user(Faker::Name.name, Faker::Internet.email, "password", "password")
      expect(page).to have_current_path(root_path)
    end

    it "登録後にフラッシュメッセージが表示されること" do
      register_user(Faker::Name.name, Faker::Internet.email, "password", "password")
      expect(page).to have_content("ユーザー登録が完了しました")
    end
  end

  context "when 不正な情報が入力された場合" do
    it "ユーザー名が無効な場合は登録できない" do
      expect do
        register_user("", Faker::Internet.email, "password", "password")
      end.not_to change(User, :count)
    end

    it "メールアドレスが無効な場合は登録できない" do
      expect do
        register_user(Faker::Name.name, "example.com", "password", "password")
      end.not_to change(User, :count)
    end

    it "パスワードが無効な場合は登録できない" do
      expect do
        register_user(Faker::Name.name, Faker::Internet.email, "abc", "abc")
      end.not_to change(User, :count)
    end

    it "パスワードとパスワード確認が一致しない場合は登録できない" do
      expect do
        register_user(Faker::Name.name, Faker::Internet.email, "password", "12345678")
      end.not_to change(User, :count)
    end

    it "再度登録ページが表示されること" do
      register_user(Faker::Name.name, "example.com", "password", "password")
      expect(current_path).to eq new_user_path
    end

    it "フォームに入力したユーザー名の情報が残ること" do
      register_user("testuser", "example.com", "password", "password")
      expect(find_field("user_name").value).to eq("testuser")
    end

    it "フォームに入力したメールアドレスの情報が残ること" do
      register_user("testuser", "example.com", "password", "password")
      expect(find_field("user_email").value).to eq("example.com")
    end
  end
end
