require 'rails_helper'

describe 'routing to articles' do
  it 'should routes /articles to articles#index' do
    expect(get('/articles')).to route_to('articles#index')
  end

  it 'should routes /show to articles#show' do
    expect(get('/articles/1')).to route_to('articles#show', id: '1')
  end

  it 'should routes /create to articles#create' do
    expect(post('/articles')).to route_to('articles#create')
  end

  it 'should routes /update to articles#update' do
    expect(put('/articles/1')).to route_to('articles#update', id: '1')
  end
end
