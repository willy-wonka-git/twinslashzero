module ApplicationHelper
  def full_title(title)
    base_title = 'Ads'
    title.empty? ? base_title : [title, base_title].join(' | ')
  end
end
