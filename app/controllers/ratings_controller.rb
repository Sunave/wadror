class RatingsController < ApplicationController
  def index
    # Uses app/workers/update_rating_worker.rb to refresh cache content every 10 minutes
    # View is cached
    # Changed to Puma instead of WEBrick
    UpdateRatingWorker.perform_async if Rails.cache.read("styles top 3").nil?
    @ratingcount = Rating.count
    @recents = Rails.cache.read "recent ratings"
    @top_breweries = Rails.cache.read "breweries top 3"
    @top_beers = Rails.cache.read "beers top 3"
    @top_raters = Rails.cache.read "raters top 3"
    @top_styles = Rails.cache.read "styles top 3"
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
