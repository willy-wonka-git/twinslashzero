
desc "Archive published posts every day in 23:50"
task :archive_published => :environment do
  # set current user for tasks
  User.current_user = User.find_by(nickname: 'admin')
  
  puts "Updating feed: archive published..."
  Post.archive_published
  puts "done."
end

desc "Publish approved posts every 10 minutes"
task :publish_approved => :environment do
  # set current user for tasks
  User.current_user = User.find_by(nickname: 'admin')

  puts "Updating feed: publish approved..."
  Post.publish_approved
  puts "done."
end