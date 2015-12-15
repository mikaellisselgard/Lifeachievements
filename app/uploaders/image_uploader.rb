# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  process :store_dimensions
  process :fix_exif_rotation
  process :extract_geolocation
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

  def get_exif(name)
    manipulate! do |img|
      return img["EXIF:" + name]
    end
  end

  def extract_geolocation
    img_lat = begin
                get_exif("GPSLatitude").split(", ")
              rescue
                nil
              end
    img_lng = begin
                get_exif("GPSLongitude").split(", ")
              rescue
                nil
              end

    lat_ref = begin
                get_exif("GPSLatitudeRef")
              rescue
                nil
              end
    lng_ref = begin
                get_exif("GPSLongitudeRef")
              rescue
                nil
              end

    return unless img_lat && img_lng && lat_ref && lng_ref

    # from [\"56/1\", \"10/1\", \"432/100\"] to 56.16786666666666
    latitude = to_frac(img_lat[0]) + (to_frac(img_lat[1]) / 60) + (to_frac(img_lat[2]) / 3600)
    longitude = to_frac(img_lng[0]) + (to_frac(img_lng[1]) / 60) + (to_frac(img_lng[2]) / 3600)

    latitude *= -1 if lat_ref == "S" # (N is +, S is -)
    longitude *= -1 if lng_ref == "W" # (W is -, E is +)

    model.latitude = latitude
    model.longitude = longitude
  end

  def to_frac(strng)
    numerator, denominator = strng.split("/").map(&:to_f)
    denominator ||= 1
    numerator / denominator
  end

  private

  def store_dimensions
    return unless file && model
    height = 280
    width_before, height_before = `identify -format "%wx%h" #{file.path}`.split(/x/)
    dimension = height_before.to_f / width_before.to_f
    model.width = height
    model.height = height * dimension
  end
end
