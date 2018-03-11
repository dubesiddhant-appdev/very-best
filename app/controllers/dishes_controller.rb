class DishesController < ApplicationController
before_action :current_user_must_be_bookmark_user, :only => [:edit, :update, :destroy]

  def current_user_must_be_bookmark_user
    bookmark = Bookmark.find(params[:id])

    unless current_user == bookmark.user
      redirect_back :fallback_location => "/", :alert => "You are not authorized for that."
    end
  end

  def index
    @q = current_user.bookmarks.ransack(params[:q])
      @bookmarks = @q.result(:distinct => true).includes(:user, :venue, :dish).page(params[:page])
      @dishes = Dish.all

    render("bookmarks/index.html.erb")
  end

  def show
    @bookmark = Bookmark.find(params[:id])

    render("bookmarks/show.html.erb")
  end

  def new
    @bookmark = Bookmark.new

    render("bookmarks/new.html.erb")
  end

  def create
    @bookmark = Bookmark.new

    @bookmark.dish_id = params[:dish_id]
    @bookmark.venue_id = params[:venue_id]
    @bookmark.user_id = params[:user_id]
    @bookmark.notes = params[:notes]

    save_status = @bookmark.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/bookmarks/new", "/create_bookmark"
        redirect_to("/bookmarks")
      else
        redirect_back(:fallback_location => "/", :notice => "Bookmark created successfully.")
      end
    else
      render("bookmarks/new.html.erb")
    end
  end

  def edit
    @bookmark = Bookmark.find(params[:id])

    render("bookmarks/edit.html.erb")
  end

  def update
    @bookmark = Bookmark.find(params[:id])

    @bookmark.dish_id = params[:dish_id]
    @bookmark.venue_id = params[:venue_id]
    @bookmark.user_id = params[:user_id]
    @bookmark.notes = params[:notes]

    save_status = @bookmark.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/bookmarks/#{@bookmark.id}/edit", "/update_bookmark"
        redirect_to("/bookmarks/#{@bookmark.id}", :notice => "Bookmark updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Bookmark updated successfully.")
      end
    else
      render("bookmarks/edit.html.erb")
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])

    @bookmark.destroy

    if URI(request.referer).path == "/bookmarks/#{@bookmark.id}"
      redirect_to("/", :notice => "Bookmark deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Bookmark deleted.")
    end
  end
end
