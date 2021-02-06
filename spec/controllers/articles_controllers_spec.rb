require 'rails_helper'

def response_json
  JSON.parse(response.body)['data']
end

describe ArticlesController do
  describe '#index' do
    subject { get :index }
    it 'should return success status code' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should be propper json' do
      create_list :article, 2
      subject
      Article.newest.each_with_index do |item, index|
        expect(response_json[index]['attributes']).to eq(
          { 'title' => item.title,
            'slug' => item.slug,
            'content' => item.content }
        )
      end
    end

    it 'should order articles by date' do
      article_0 = create :article
      article_new = create :article
      subject
      expect([response_json[0]['id'].to_i, response_json[1]['id'].to_i]).to eq([article_new.id, article_0.id])
    end

    it 'should paginate' do
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
                                                    'title' => article.title,
                                                    'content' => article.content,
                                                    'slug' => article.slug
                                                  })
      end
    end
  end

  describe '#create' do
    context 'user is not authorized' do
      it 'should return forbidden resource accesss code when no access code in header' do
        post :create
        expect(response).to have_http_status(403)
      end

      before { request.headers['authorization'] = 'Invalid' }
      it 'should return forbidden resource accesss code when invalid access code in header' do
        post :create
        expect(response).to have_http_status(403)
      end
    end

    context 'user is authorized' do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }
      let(:valid_params) do
        { 'data' => { 'attributes' =>
            { 'title' => 'my test title', 'content' => 'my test content', 'slug' => 'my-test-slug' } } }
      end

      it 'and should return resource created code and create article' do
        post :create, params: valid_params
        expect(response).to have_http_status(201)
      end

      it 'should create the article' do
        expect { post :create, params: valid_params }.to change { Article.count }.by(1)
      end

      it 'but invalid parameters are provided return Unprocessable Entity Code' do
        post :create, params: { something: 'something' }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe '#update' do
    let(:user) { create :user }
    let(:access_token) { user.create_access_token }
    let(:article) { create :article }
    let(:valid_update_params) do
      { 'id' => article.id.to_s, 'data' => { 'attributes' =>
          { 'title' => 'a new fresh title' } } }
    end

    context 'correct paramters' do
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }
      it 'should update the article' do
        put :update, params: valid_update_params
        expect(Article.find(article.id).title).to eq('a new fresh title')
      end
    end

    context 'incorrect header' do
      it 'should return error when no header' do
        request.headers['authorization'] = 'Invalid'
        put :update, params: valid_update_params
        expect(response).to have_http_status(403)
      end
    end
  end
end
