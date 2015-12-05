class Medal < ActiveRecord::Base
  belongs_to :user
  
  def self.generate_medals
    @user_stats = []
    @highest_max_score = 0
    @highest_max_score_count = 0
    @user_with_highest_max = ""
    
    User.all.each do |user|
      user_posts = user.posts.joins(:achievement).
                          where('achievements.created_at between ? and ?',
                          Time.now - 10.days, Time.now)
                          
      achievements_earned = user_posts.length
      score = user_posts.sum(:score)
      max_score = user_posts.maximum(:score).to_f
      max_score_count = user_posts.where('achievements.score = ?', max_score).count
      likes = user_posts.sum(:likes_count)  
      
      @user_stats.push({
        "user_id" => user.id,
        "achievements_earned" => achievements_earned,
        "score" => score,
        "likes" => likes
        })
        
        # check if user has higher max_score or more max_score_counts
        if max_score >= @highest_max_score && max_score_count > @highest_max_score_count
          @highest_max_score = max_score
          @user_with_highest_max = user.id
          @highest_max_score_count = max_score_count
        end
      
      end
      
    user_with_highest_achievements_earned = @user_stats.max_by { |k| k["achievements_earned"] }["user_id"]
    user_with_highest_score = @user_stats.max_by { |k| k["score"] }["user_id"]
    user_with_highest_likes = @user_stats.max_by { |k| k["likes"] }["user_id"]
    
    # create the medal for the user
    Medal.new({ user_id: user_with_highest_score, type: 'mest poäng', image: 'score_medal.png' }).save
    Medal.new({ user_id: user_with_highest_achievements_earned, type: 'flest antal', image: 'amount_medal.png' }).save
    Medal.new({ user_id: @user_with_highest_max, type: 'flest ovanliga', image: 'max_medal.png' }).save
    Medal.new({ user_id: user_with_highest_likes, type: 'flest likes', image: 'likes_medal.png' }).save
    
    # create notice for each medal
    Notice.medal(user_with_highest_score, 'mest poäng')
    Notice.medal(user_with_highest_achievements_earned, 'flest antal')
    Notice.medal(@user_with_highest_max, 'flest ovanliga')
    Notice.medal(user_with_highest_likes, 'flest likes')
    
  end
  
  
  private

  #setting inheritance to nil, to use type as a column
  def self.inheritance_column
    nil
  end
    
end
