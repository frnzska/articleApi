require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#validations" do
    it "should check valid login" do
      user = create :user
      expect(user).to be_valid

      expect{
        user1 = create :user, login: nil
      }.to raise_error

      new_user = build :user, login: user.login
      expect(new_user).not_to be_valid

    end
  end
end
