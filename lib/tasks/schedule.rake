desc "Archive published posts every day in 23:50"
task archive_published: :environment do
  Current.user = User.find_by(nickname: 'admin')

  puts "Updating feed: archive published..."
  Post.archive_published
  puts "Done."
end

desc "Publish approved posts every 10 minutes"
task publish_approved: :environment do
  Current.user = User.find_by(nickname: 'admin')

  puts "Updating feed: publish approved..."
  Post.publish_approved
  puts "Done."
end

desc "Delete posts image cache every 15 minutes"
task delete_post_cache: :environment do
  puts "Updating feed: delete posts cache..."
  ImageCache.delete_old_cache
  puts "Done."
end
