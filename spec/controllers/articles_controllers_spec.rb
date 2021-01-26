require 'rails_helper'

describe ArticlesController do
    describe '#index' do
        it "should return success status code" do
            get :index
            expect(response).to have_http_status(:ok)
        end

        it 'should be propper json' do
            create_list :article, 2
            get :index
            json = JSON.parse(response.body)
            pp json
            expect(json['data'])
        end


    end
end