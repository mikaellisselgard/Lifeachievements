# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  process :store_dimensions
  process :fix_exif_rotation
  process :extract_geolocation
  process :resize_to_fit => [280, 1000]
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def fix_exif_rotation
    manipulate! do |img|
      img = img.auto_orient
    end
  end
  
  def get_exif( name )
    manipulate! do |img|
      return img["EXIF:" + name]
    end
  end
  
  def extract_geolocation
    img_lat = get_exif('GPSLatitude').split(', ') rescue nil
    img_lng = get_exif('GPSLongitude').split(', ') rescue nil
    
    lat_ref = get_exif('GPSLatitudeRef') rescue nil
    lng_ref = get_exif('GPSLongitudeRef') rescue nil
    
    return unless img_lat && img_lng && lat_ref && lng_ref
    
    # from [\"56/1\", \"10/1\", \"432/100\"] to 56.16786666666666
    latitude = to_frac(img_lat[0]) + (to_frac(img_lat[1])/60) + (to_frac(img_lat[2])/3600)
    longitude = to_frac(img_lng[0]) + (to_frac(img_lng[1])/60) + (to_frac(img_lng[2])/3600)
    
    latitude = latitude * -1 if lat_ref == 'S'  # (N is +, S is -)
    longitude = longitude * -1 if lng_ref == 'W'   # (W is -, E is +)
    
    model.latitude = latitude
    model.longitude = longitude
  end
  
  def to_frac(strng)
    numerator, denominator = strng.split('/').map(&:to_f)
    denominator ||= 1
    numerator/denominator
  end
  
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb_achievement do
    process :resize_to_fill => [100, 100]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  private

  def store_dimensions
    if file && model
      height = 280
      width_before, height_before = `identify -format "%wx%h" #{file.path}`.split(/x/)
      dimension = height_before.to_f / width_before.to_f
      model.width = height
      model.height = height * dimension
    end
  end
  
end


 
