class Medal < ActiveRecord::Base
  belongs_to :user
  
  def self.score_medal
    # most gained score medal, weekly
    @users = User.all
    @user_with_highest_score = ''
    @highest_score = 0
    @users.each do |user|
      @score = []
      user.posts.each do |post|
        #only fetching achievement gained last 7 days
        if post.created_at + 7.days > Time.now
          @score.push(post.achievement.score)
        end
      end
      # checking if score is higher than previous highest
      if @score.inject(:+) > @highest_score
        @highest_score = @score.inject(:+)
        @user_with_highest_score = user
      end
    end
    # create the medal for the user
    Medal.new({ :user_id => @user_with_highest_score.id, :type => 'score_medal', :image => 'score_medal.png' }).save
  end
  
  
  
  private

  #setting inheritance to nil, to use type as a column
  def self.inheritance_column
    nil
  end
    
end
