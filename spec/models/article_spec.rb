require 'rails_helper'

RSpec.describe Article, type: :model do

  describe "#validations" do
    it 'should check that factory is valid' do
      expect(build :article).to be_valid
    end

    it 'should validate non empty title' do
      article = build :article, title: ''
      expect(article).not_to be_valid
    end

    it 'should validate non empty content' do
      article = build :article, content: ''
      expect(article).not_to be_valid
    end

    it 'should validate non empty slug' do
      article = build :article, slug: ''
      expect(article).not_to be_valid
    end
  end
end
