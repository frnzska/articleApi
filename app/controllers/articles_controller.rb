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
    article.save!
    render json: article, status: 201
  end

  def update
    article = Article.find(params[:id])
    article.update(valid_params)
    render json: article, status: 201
  end

  private

  def valid_params
    params.require('data').require('attributes')
          .permit('title', 'content', 'slug')
  end
end
