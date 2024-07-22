module ApplicationHelper
  def page_title(title = '')
    base_title = 'Menu Maker'
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def active_if(path)
    "active" if current_page?(path)
  end
end
