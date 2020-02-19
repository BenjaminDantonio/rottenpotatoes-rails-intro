class Movie < ActiveRecord::Base
  def self.ratings
  	ratings = {}
  	self.select(:rating).uniq.each do |movie|
  		ratings[movie.rating] = 1
  	end
  	ratings
  end
  
  def self.with_ratings(ratings)
    self.where({rating: ratings})
  end
end
