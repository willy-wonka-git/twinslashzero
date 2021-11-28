module ApplicationHelper
  def full_title(title)
    base_title = 'Ads'
    title.empty? ? base_title : [title, base_title].join(' | ')
  end

  def cloudinary_asset_url(image)
    Cloudinary::Utils.cloudinary_url(image, type: :asset)
  end
end
