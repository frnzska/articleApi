require 'rails_helper'

def response_json
    JSON.parse(response.body)['data']
end

describe ArticlesController do
    describe '#index' do
        subject {get :index}
        it "should return success status code" do
            subject
            expect(response).to have_http_status(:ok)
        end

        it 'should be propper json' do
            create_list :article, 2
            subject
            Article.newest.each_with_index do |item, index| 
                expect(response_json[index]['attributes']).to eq(
                    {"title" => item.title,
                     "slug" => item.slug,
                     "content" => item.content
                    }
                )
            end
        end

        it "should order articles by date" do
            article_0 = create :article
            article_new = create :article
            subject
            expect([response_json[0]['id'].to_i, response_json[1]['id'].to_i]).to eq([article_new.id, article_0.id])
        end

        it "should paginate" do
            page_size = 10
            create_list :article, 21
            get :index, params: { page: 1, per_page: page_size }
            expect(response_json.length).to eq(page_size) 
        end



    describe '#show' do
        let(:article) { create :article }
        subject { get :show, params: { id: article.id } }
        
        it 'should return success response' do
            subject
            expect(response).to have_http_status(:ok)
        end
      
        it 'should return proper json' do
            subject
            expect(response_json['attributes']).to eq({
                "title" => article.title,
                "content" => article.content,
                "slug" => article.slug
                })
            end
        end
    end
end