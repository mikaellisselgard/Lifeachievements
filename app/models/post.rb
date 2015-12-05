class Post < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  mount_uploader :video, VideoUploader
  acts_as_followable
  acts_as_follower
  belongs_to :user
  belongs_to :achievement
  has_many :likes, dependent: :destroy
  has_many :comments, as: :imageable, dependent: :destroy

  before_create :check_achievement
  after_create :lower_achievement_score, :remove_from_bucketlist
  after_save :process_video

  before_destroy :higher_achievement_score

  default_scope { order('created_at DESC') }
  
  validate :image_or_video

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
    self.user.bucket_list.achievements.destroy(self.achievement) rescue nil
  end
  
  def check_like(user)
    self.likes.find_by_user_id(user)
  end

  def set_success(format, opts)
    self.success = true
  end
  
  def image_or_video
    if image.blank? && video.blank?
      errors.add(:image, "Finns ingen bild eller video")
    end
    unless image.blank? || video.blank?
      errors.add(:image, "Du kan inte ladda upp både bild och video")
    end
  end
  
  def process_video
    unless self.video.content_type == "application/mp4" || video.blank?
      uploaded_video = FFMPEG::Movie.new("public" + self.video.url)
      uploaded_video.transcode("public/uploads/post/video/" + self.id.to_s + "/" + self.id.to_s + ".mp4")
      self.video = Rails.root.join("public/uploads/post/video/" + self.id.to_s + "/" + self.id.to_s + ".mp4").open
      self.save!
    end
  end
  
end



