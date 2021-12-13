module PostPhotosCacheHelper
  def init_photo_cache(post, params, init)
    dir = Current.photos_cache
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

    if init || remove_photos?(params)
      delete_files(dir)
      return
    end

    cache_files = Dir["#{dir}/*"]
    post.photos_cache = []
    cache_files.each do |file|
      add_photo_cache(post, File.basename(file))
    end
  end

  def attach_photo_cache(post)
    return unless post.photos_cache

    dir = Current.photos_cache
    post.photos_cache.each do |photo|
      post.photos.attach(io: File.open(File.join(dir, File.basename(photo))), filename: File.basename(photo))
    end
    delete_files(dir)
  end

  def save_photo_cache(post, params)
    photos = params[:post][:photos]
    return unless photos

    dir = Current.photos_cache
    photos.each.with_index do |photo, i|
      filename = new_cache_filename(post.photos_cache.count, i + 1, File.extname(photo.original_filename))
      FileUtils.copy(photo.tempfile.path, File.join(dir, filename))
      add_photo_cache(post, filename)
    end
  end

  def new_cache_filename(start_index, index, extention)
    prefix = start_index + index
    prefix.to_s + rand(36**8).to_s(36) + extention
  end

  def add_photo_cache(post, filename)
    post.photos_cache << "/#{['uploads', Current.user.id.to_s, filename].join('/')}"
  end

  def remove_photos?(params)
    params[:post] && params[:post][:remove_photos] == "1"
  end

  def delete_files(dir)
    FileUtils.rm_rf(Dir["#{dir}/*"]) if dir && Dir.exist?(dir)
  end
end
