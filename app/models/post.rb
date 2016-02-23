class Post < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  mount_uploader :video, VideoUploader
  acts_as_followable
  acts_as_follower
  belongs_to :user
  belongs_to :achievement
  has_many :likes, dependent: :destroy
  has_many :comments, as: :imageable, dependent: :destroy
  has_many :reports

  before_create :check_achievement
  after_create :lower_achievement_score, :remove_from_bucketlist
  after_save :process_video

  before_destroy :higher_achievement_score

  default_scope { order('created_at DESC') }
  
  validate :image_or_video

  def has_image?
    !has_video?
  end

  def has_video?
    height == nil
  end

  def check_achievement
    self.achievement.users.exclude? self.user
  end
  
  def lower_achievement_score
    if self.achievement.score != 5 && self.achievement.users.count > 1
      self.achievement.update_attributes(score: self.achievement.score - 5)
    end
  end

  def higher_achievement_score
    if self.achievement.score < 100 && self.achievement.users.count < 20
      self.achievement.update_attributes(score: self.achievement.score + 5)
    end
  end
  
  def remove_from_bucketlist
    self.user.bucket_list.achievements.destroy(self.achievement)
  end
  
  def check_like(user)
    self.likes.find_by_user_id(user)
  end

  def set_success(format, opts)
    self.success = true
  end
  
  def report_post(user)
    self.reports.create(user_id: user.id, status: 0)
  end
  
  def image_or_video
    if image.blank? && video.blank?
      errors.add(:image, "Finns ingen bild eller video")
    end
  end
  
  def process_video
    if self.video.content_type != "application/mp4" && image.url.blank? && video
      uploaded_video = FFMPEG::Movie.new("public" + self.video.url)
      uploaded_video.screenshot("public/uploads/post/video/" + self.id.to_s + "/" + self.id.to_s + ".jpg")
      uploaded_video.transcode("public/uploads/post/video/" + self.id.to_s + "/" + self.id.to_s + ".mp4")
      self.video = Rails.root.join("public/uploads/post/video/" + self.id.to_s + "/" + self.id.to_s + ".mp4").open
      self.image = File.open("public/uploads/post/video/" + self.id.to_s + "/" + self.id.to_s + ".jpg")
      self.save!
    end
  end
  
end



