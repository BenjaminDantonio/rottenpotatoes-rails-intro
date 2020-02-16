class Movie < ActiveRecord::Base
  def self.ratings
    ['G','PG','PG-13','R','NC-17']
  end
  
  def self.with_ratings(ratings)
    self.where({rating: ratings})
  end
end
