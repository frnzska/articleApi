require 'rails_helper'

#describe 'articles routes' do
   # it 'should route to articles index' do
   #     #expect(gets('/articles')).to_route_to('articles#index')
   #     puts gets('articles')
   # end

    
    describe "routing to articles" do
      it "routes /articles to articles#index" do
        expect(get "/articles").to route_to(
          'articles#index'
        )
      end
end