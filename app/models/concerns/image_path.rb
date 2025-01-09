module ImagePath
  extend ActiveSupport::Concern

  included do
    before_create :set_image_paths
    before_update :set_image_paths
  end

  private

  def set_image_paths
    [ :image1, :image2, :image3, :image4, :image5 ].each do |column|
      if will_save_change_to_attribute?(column)
        uploader = send(column)
        if uploader&.file&.exists?
          file_name = uploader.filename
          rec_image_dir = "image-#{send(:id)}"
          uploader.store_dir = "media/#{rec_image_dir}"
          self[column] = "#{rec_image_dir}/#{file_name}"
          uploader.store!
        end
      end
    end
  end
end
