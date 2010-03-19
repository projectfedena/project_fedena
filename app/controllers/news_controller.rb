class NewsController < ApplicationController
  before_filter :login_required

  filter_access_to :all

  def add
    @news = News.new(params[:news])
    @news.author = current_user
    if request.post? and @news.save
      flash[:notice] = 'News added!'
      redirect_to :controller => 'news', :action => 'index'
    end
  end

  def add_comment
    @cmnt = NewsComment.new(params[:comment])
    @cmnt.author = current_user
    @cmnt.save
  end

  def all
    @news = News.find(:all, :order => 'created_at DESC')
  end

  def delete
    @news = News.find(params[:id]).destroy
    flash[:notice] = 'News item deleted succefully!'
    redirect_to :controller => 'news', :action => 'index'
  end

  def delete_comment
    @comment = NewsComment.find(params[:id])
    NewsComment.destroy(params[:id])
  end

  def edit
    @news = News.find(params[:id])
    if request.post? and @news.update_attributes(params[:news])
      flash[:notice] = 'News updated!'
      redirect_to :controller => 'news', :action => 'view', :id => @news.id
    end
  end

  def index
    @current_user = current_user
    @news = nil
    if request.get?
      unless params[:query].nil?
        query_terms1 = params[:query].split(" ")
        query_terms2 = params[:query].split(" ")
        conditions = "(title LIKE \"%#{query_terms1.pop}%\""
        query_terms1.each do |q|
          conditions += " AND title LIKE \"%#{q}%\""
        end
        conditions += ") OR (content LIKE \"%#{query_terms2.pop}%\""
        query_terms2.each do |q|
          conditions += " AND content LIKE \"%#{q}%\""
        end
        conditions += ")"
      else
        conditions = 'false'
      end
      @news = News.find(:all, :order => 'created_at DESC', :conditions => conditions )
    else
      @news = nil
    end
  end

  def search_news_ajax
    @news = nil
    conditions = ["title LIKE ?", "%#{params[:query]}%"]
    @news = News.find(:all, :conditions => conditions) unless params[:query] == ''
    render :layout => false
  end

  def view
    @current_user = current_user
    @news = News.find(params[:id])
    @comments = @news.comments
  end

end
