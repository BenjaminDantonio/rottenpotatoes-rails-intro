class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  #def index
  #  @movies = Movie.all
  #end
  
  def index
    self.allRatings
    if(!params.has_key?(:sort) && !params.has_key?(:direction) && !params.has_key?(:ratings))
      if(session.has_key?(:sort) || session.has_key?(:direction) || session.has_key?(:ratings))
        redirect_to movies_path(:sort=>session[:sort], :direction=>session[:direction], :ratings=>session[:ratings])
      end
    end
    @sort_item = params.has_key?(:sort) ? (session[:sort] = params[:sort]) : session[:sort]
    @sort_direction = params.has_key?(:direction) ? (session[:direction] = params[:direction]) : session[:direction]
    if !params.has_key?(:ratings)
      if (!params.has_key?(:commit) && !params.has_key?(:sort)&& !params.has_key?(:direction))
        @current_ratings = Movie.ratings.keys
        session[:ratings] = Movie.ratings
      else
        @current_ratings = session[:ratings].keys
      end
    else
      session[:ratings] = params[:ratings]
      @current_ratings = params[:ratings].keys
      self.filterMovies
    end
    if session.has_key?(:sort)
      self.filterMovies
      if session[:sort] == 'title'
        @title_header = 'hilite'
      elsif session[:sort] == 'release_date'
        @release_header ='hilite'
      end
    end
    self.filterMovies
  end

  def allRatings
    @all_ratings = Movie.ratings.keys
  end
  
  def filterMovies
    displayedRatings = session[:ratings].keys
    if @sort_item != nil
      @movies = Movie.order(@sort_item + " " + @sort_direction).with_ratings(@current_ratings)
    else
      @movies = Movie.with_ratings(@current_ratings)
    end
  end
  
  def new
    # default: render 'new' template | Ben: This is done by default, I guess because of Ruby convention
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
