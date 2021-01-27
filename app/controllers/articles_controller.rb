
class ArticlesController < ApplicationController

    def index
        articles = Article.newest.
        page(params[:page]).
        per(params[:per_page])
        render json: articles
    end

    def show
        render json: Article.find(params[:id])
    end
end