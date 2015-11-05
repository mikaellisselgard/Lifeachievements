class Medal < ActiveRecord::Base
  belongs_to :user
  
  def self.generate_medals
    # most gained score medal and most achievement done, weekly
    @users = User.all
    @user_with_highest_score = ''
    @user_with_highest_amount = ''
    @user_with_highest_max = ''
    @highest_score = 0 # highest score gained from achievement achieved
    @highest_amount = 0 # highest amount of achievements earned
    @max_score = 0 # score of highest achievement
    @amount_of_max_score = 0 # times gained achievements with max score
    @users.each do |user|
      @score = []
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
        @user_with_highest_max = user
        @amount_of_max_score = @score.count(@score.max)
      end
      # checking if highest score gained is the same but achieved more times
      if @score.max == @max_score && @score.count(@score.max) > @amount_of_max_score
        @user_with_highest_max = user
        @amount_of_max_score = @score.count(@score.max)
      end
    end
    # create the medal for the user
    Medal.new({ user_id: @user_with_highest_score.id, type: 'score_medal', image: 'score_medal.png' }).save
    Medal.new({ user_id: @user_with_highest_amount.id, type: 'amount_medal', image: 'amount_medal.png' }).save
    Medal.new({ user_id: @user_with_highest_max.id, type: 'max_medal', image: 'max_medal.png' }).save
  end
  
  
  private

  #setting inheritance to nil, to use type as a column
  def self.inheritance_column
    nil
  end
    
end
