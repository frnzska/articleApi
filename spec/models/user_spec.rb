require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    it 'should check valid login' do
      user = create :user
      expect(user).to be_valid

      expect  do
        user1 = create :user, login: nil
      end.to raise_error(ActiveRecord::RecordInvalid)

      new_user = build :user, login: user.login
      expect(new_user).not_to be_valid
    end
  end
end
