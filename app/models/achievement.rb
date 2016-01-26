class Achievement < ActiveRecord::Base
  has_many :users, through: :posts
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :bucket_lists
  has_many :posts, dependent: :destroy
  belongs_to :user

  default_scope { order("created_at DESC") }

  validates :description, presence: true

  after_create :set_score

  def set_score
    self.score = 100
    self.save!
  end

  def self.generate_new_achievements
    # first file in lib/assets/not_used/
    first_file = Dir.glob("lib/assets/not_used/*").first
    File.open(first_file) do |file|
      file.each_line do |line|
        new(description: line.chomp, user_id: 1).save
      end
    end
    # rename and save file in used
    File.rename first_file, "lib/assets/used/#{first.id}"
  end
end
