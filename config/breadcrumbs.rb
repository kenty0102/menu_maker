crumb :root do
  link "Top", root_path
end

crumb :search_recipes do
  link "レシピ検索", search_recipes_path
  parent :root
end

crumb :save_options_recipes do
  link "レシピの保存方法", save_options_recipes_path
  parent :root
end

crumb :auto_save_recipes do
  link "レシピの自動保存", auto_save_recipes_path
  parent :save_options_recipes
end

crumb :new_recipe do
  link "レシピの手動保存", new_recipe_path
  parent :save_options_recipes
end

crumb :recipes do
  link "レシピ一覧", recipes_path
  parent :root
end

crumb :recipe do |recipe| # レシピ詳細ページ
  link recipe.title, recipe_path(recipe)
  parent :recipes
end

crumb :edit_recipe do |recipe|
  link "レシピ編集", edit_recipe_path(recipe)
  if request.referer == recipes_url # 完全一致を確認する
    parent :recipes
  else
    parent :recipe, recipe
  end
end

crumb :new_menu do
  link "メニュー表作成", new_menu_path
  parent :root
end

crumb :menus do
  link "メニュー表一覧", menus_path
  parent :root
end

crumb :menu do |menu|
  link menu.title, menu_path(menu)
  parent :menus
end

crumb :edit_menu do |menu|
  link "メニュー表編集", edit_menu_path(menu)
  if request.referer == menus_url # 完全一致を確認する
    parent :menus
  else
    parent :menu, menu
  end
end

crumb :profile do
  link "マイページ", profile_path
  parent :root
end

crumb :edit_username_profile do
  link "ユーザー名編集", edit_username_profile_path
  parent :profile
end

crumb :edit_email_profile do
  link "メールアドレス編集", edit_email_profile_path
  parent :profile
end

crumb :edit_password_profile do
  link "パスワード変更", edit_password_profile_path
  parent :profile
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).