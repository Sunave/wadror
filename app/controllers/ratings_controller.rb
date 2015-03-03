class RatingsController < ApplicationController
  def index

    # View is cached
    # Changed to Puma webserver, which seems to be faster
    # There used to be a different caching thread that used sidekiq,
    # which used app/workers/update_rating_worker, but it didn't work out with Heroku so it's disabled.
    # Now it just fetches to caches so that after first loading, they expire at different times.
    # There's a slight possibility that this evens the load between different page loads.

    @ratingcount = Rating.count
    @recents = Rails.cache.fetch("recent ratings", expires_in: 10.minutes) { Rating.recent }
    @top_breweries = Rails.cache.fetch("breweries top 3", expires_in: 9.minutes)  { Brewery.top 3 }
    @top_beers = Rails.cache.fetch("beers top 3", expires_in: 11.minutes) { Beer.top 3 }
    @top_raters = Rails.cache.fetch("raters top 3", expires_in: 16.minutes) { User.includes(:beers, :ratings).top_raters(3) }
    @top_styles = Rails.cache.fetch("styles top 3", expires_in: 8.minutes) { Style.top 3 }
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end
