module PostPhotosCacheHelper
  include Rails.application.routes.url_helpers

  def cache_init(post, init)
    if init
      clear_cache(post, post.author)
      post.photos.each do |photo|
        create_photo_cache(post, photo.key)
      end
    end
    post.photos_cache = ImageCache.where(post: post, user: post.author).all
  end

  def cache_add(post, params)
    images = []
    errors = []
    params.each do |k, v|
      next unless k[0, 5] == 'photo' || images.size == 10

      key = save_file(v, errors)
      next unless key

      create_photo_cache(post, key)
      images << key
    end
    { images: images, errors: errors }
  end

  def save_file(file, errors)
    return unless file_valid(file, errors)

    filename = new_cache_filename(File.extname(file.original_filename))
    FileUtils.copy(file.tempfile.path, File.join(Current.photos_cache, filename))
    "/#{['uploads', Current.user.id.to_s, 'photos', filename].join('/')}"
  end

  def cache_delete(post, user, key = null)
    filter = { post: post, user: user }
    filter[:key] = key if key
    ImageCache.where(filter).destroy_all
    :success
  end

  def cache_save(post, new_post)
    remove_deleted_attachments(post) unless new_post
    create_new_attachments(post, new_post)
    clear_cache(new_post ? nil : post, post.author)
  end

  def clear_cache(post, user)
    ImageCache.where(post: post, user: user).destroy_all
  end

  def remove_deleted_attachments(post)
    post.photos.each do |photo|
      photo.purge unless ImageCache.find_by(post: post, user: post.author, key: photo.key)
    end
  end

  def create_new_attachments(post, new_post)
    ImageCache.where(post: new_post ? nil : post, user: post.author).each do |cache|
      next if cache.attachment?

      filename = File.basename(cache.key)
      post.photos.attach(io: File.open(File.join(Current.photos_cache, filename)), filename: filename)
    end
  end

  def file_valid(file, errors)
    err_count = errors.size
    size = File.size(file.tempfile.path)
    type = file.content_type

    errors << "#{file.original_filename} invalid type." if %w[image/jpeg image/jpg image/png image/gif].exclude?(type)
    errors << "#{file.original_filename} invalid size." if size.zero? || size > 2**20
    errors.size == err_count
  end

  def new_cache_filename(extention)
    "cache_#{rand(36**8).to_s(36)}#{extention}"
  end

  def create_photo_cache(post, key)
    image_cache = ImageCache.create
    image_cache.post = post
    image_cache.user = post.author
    image_cache.key = key
    image_cache.save
  end
end
