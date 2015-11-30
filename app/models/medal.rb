class Medal < ActiveRecord::Base
  belongs_to :user
  
  def self.generate_medals
    # most gained score medal and most achievement done, weekly
    @users = User.all
    @user_with_highest_score = ''
    @user_with_highest_amount = ''
    @user_with_highest_max = ''
    @user_with_most_likes = ''
    @highest_score = 0 # highest score gained from achievement achieved
    @highest_amount = 0 # highest amount of achievements earned
    @max_score = 0 # score of highest achievement
    @amount_of_max_score = 0 # times gained achievements with max score
    @highest_likes = 0
    @users.each do |user|
      @score = []
      if user.posts.where(:created_at => Time.now - 7.days..Time.now).sum(:likes_count) > @highest_likes
        @highest_likes = user.posts.where(:created_at => Time.now - 7.days..Time.now).sum(:likes_count)
        @user_with_most_likes = user
      end
      if user.posts.any?
        user.posts.each do |post|
          # only fetching achievement gained last 7 days
          if post.created_at + 7.days > Time.now
            @score.push(post.achievement.score)
          end
        end
        # checking if score is higher than previous highest
        if @score.inject(:+) > @highest_score
          @highest_score = @score.inject(:+)
          @user_with_highest_score = user
        end
        # checking if achievement amount is higher than previous highest
        if @score.length > @highest_amount
          @highest_amount = @score.length
          @user_with_highest_amount = user
        end
        # checking if highest score gained is higher than previous highest 
        if @score.max > @max_score
          @max_score = @score.max
          @user_with_highest_max = user
          @amount_of_max_score = @score.count(@score.max)
        end
        # checking if highest score gained is the same but achieved more times
        if (@score.max == @max_score) and (@score.count(@score.max) > @amount_of_max_score)
          @user_with_highest_max = user
          @amount_of_max_score = @score.count(@score.max)
        end
      end
    end
    # create the medal for the user
    Medal.new({ user_id: @user_with_highest_score.id, type: 'mest poäng', image: 'score_medal.png' }).save
    Medal.new({ user_id: @user_with_highest_amount.id, type: 'flest antal', image: 'amount_medal.png' }).save
    Medal.new({ user_id: @user_with_highest_max.id, type: 'flest ovanliga', image: 'max_medal.png' }).save
    Medal.new({ user_id: @user_with_most_likes.id, type: 'flest likes', image: 'likes_medal.png' }).save
    # create notice for each medal
    Notice.medal(@user_with_highest_score.id, 'mest poäng')
    Notice.medal(@user_with_highest_amount.id, 'flest antal')
    Notice.medal(@user_with_highest_max.id, 'flest ovanliga')
    Notice.medal(@user_with_most_likes.id, 'flest likes')
  end
  
  
  private

  #setting inheritance to nil, to use type as a column
  def self.inheritance_column
    nil
  end
    
end
