class ArticlesController < ApplicationController
  before_action :authorize!, only: %i[create update]

  def index
    articles = Article.newest
                      .page(params[:page])
                      .per(params[:per_page])
    render json: articles
  end

  def show
    render json: Article.find(params[:id])
  end

  def create
    attributes = valid_params
    article = Article.create(**attributes)
    render json: article, status: 201
  rescue StandardError
    render json: { "message": 'too lazy to properly implement this error msg right now.' }, status: 422
  end

  def update
    article = Article.find(params[:id])
    article.update(valid_params)
    render json: article, status: 201
  rescue StandardError
    render json: { "message": 'again too lazy to properly implement this error msg.' }, status: 422
  end

  private

  def valid_params
    params.require('data').require('attributes')
          .permit('title', 'content', 'slug')
  end
end
