
class ArticlesController < ApplicationController

    def index
        render json: Article.all, adapter: :json_api # serializer config not working, workaround for now
    end

    def show
        render json: Article.find(params[:id]), adapter: :json_api 
    end
end