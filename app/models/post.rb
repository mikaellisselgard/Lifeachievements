class Post < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  mount_uploader :video, VideoUploader
  acts_as_followable
  acts_as_follower
  belongs_to :user, touch: true
  belongs_to :achievement, counter_cache: true, touch: true
  has_many :likes, dependent: :destroy
  has_many :comments, as: :imageable, dependent: :destroy
  has_many :reports, dependent: :destroy

  before_create :check_achievement
  after_create :lower_achievement_score, :remove_from_bucketlist
  after_create :set_image
  after_save :process_video
  before_destroy :higher_achievement_score
  before_destroy :remove_notice_links

  default_scope { order('created_at DESC') }
  
  validate :image_or_video

  def has_video?
    !video.file.nil?
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
  
  def remove_notice_links
    Notice.where(notice_type: ['comment', 'like']).where(link: id).destroy_all
  end
  
  def check_like(user)
    if self.likes.find_by_user_id(user)
      return true
    else
      return false
    end
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

  #Set image from video column and remove uploaded image from video if uploaded record is an image
  def set_image
    if self.video.content_type && self.video.content_type.split('/')[0] == 'image'
      self.image = self.video
      self.remove_video!
      self.save
    end
  end

  def comments_count
    self.comments.count 
  end

  def commenter_infos
    commenter_user_names = []
    commenter_user_avatars = []
    commenter_user_ids = []
    commenter_comments = []
    self.comments.each do |comment|
      commenter_user_names.push(comment.user.name)
      commenter_user_avatars.push(comment.user.avatar_url)
      commenter_user_ids.push(comment.user.id)
      commenter_comments.push(comment.comment)
    end
    [commenter_user_names, commenter_user_avatars, commenter_user_ids, commenter_comments]
  end
  
  def like_infos
    like_user_names = []
    like_user_avatars = []
    like_user_ids = []
    self.likes.each do |like|
      like_user_names.push(like.user.name)
      like_user_avatars.push(like.user.avatar_url)
      like_user_ids.push(like.user.id)
    end
    [like_user_names, like_user_avatars, like_user_ids]
  end
  
end



