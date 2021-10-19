class Post < ApplicationRecord
	belongs_to :author, class_name: "User"
	belongs_to :category, class_name: "PostCategory"

	validates :category, :title, :content, presence: true
	
    validates :title, length: { minimum: 5, maximum: 200 }
    validates :content, length: { minimum: 50, maximum: 2000 }
end
