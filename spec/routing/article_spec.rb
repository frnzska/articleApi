require 'rails_helper'
    
    describe "routing to articles" do
      it 'should routes /articles to articles#index' do
        expect(get "/articles").to route_to('articles#index')
      end

      it "should routes /show to articles#show" do
        expect(get '/articles/1').to route_to('articles#show', id: '1')
      end
end