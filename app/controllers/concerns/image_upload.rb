module ImageUpload
  extend ActiveSupport::Concern

  def save_images(model, model_sym)
    [ :image1, :image2, :image3, :image4, :image5 ].each do |image|
      if params[model_sym][image].present?
        uploaded_file = params[model_sym][image]
        image_id = SecureRandom.uuid.to_s
        image_path = "image-#{model.id}/#{image_id}#{File.extname(uploaded_file)}"
        image_file_path = Rails.root.join("public", "media", image_path)
        FileUtils.mkdir_p(File.dirname(image_file_path))
        File.open(image_file_path, "wb") do |file|
          file.write(uploaded_file.read)
        end
        model.update(image1: image_path)
      end
    end
  end
end
