require 'rails_helper'

RSpec.describe AccessToken, type: :model do

    describe "#validations" do
      it 'should check that factory is valid' do
        
        expect(create :access_token).to be_valid
      end
  end
end
