class DishesController < ApplicationController

  def index
    @q = Dish.ransack(params[:q])
    @dishes = @q.result(:distinct => true).includes(:cuisine, :bookmarks, :fans, :specialists).page(params[:page])
    @bookmarks = Bookmark.all
    @cuisines = Cuisine.all.sort_by(&:name)

    render("dishes/index.html.erb")
  end

  def show
      @bookmark = Bookmark.new
      @dish = Dish.find(params[:id])

    render("dishes/show.html.erb")
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
