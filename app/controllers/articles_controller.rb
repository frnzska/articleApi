
class ArticlesController < ApplicationController
    before_action :authorize!, only: [:create]

    def index
        articles = Article.newest.
        page(params[:page]).
        per(params[:per_page])
        render json: articles
    end

    def show
        render json: Article.find(params[:id])
    end


    def create
        begin
            attributes = get_params
            article = Article.create(**attributes)
            render json: article, status: 201
        rescue
            render json: {"message": "too lazy to properly implement this error msg right now."}, status: 422
        end 
    end

    private
    def get_params
        params.require("data").require("attributes").
      permit("title", "content", "slug") 
    end

end
