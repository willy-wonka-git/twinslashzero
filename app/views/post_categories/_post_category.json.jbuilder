json.extract! post_category, :id, :title, :description, :created_at, :updated_at
json.url post_category_url(post_category, format: :json)
