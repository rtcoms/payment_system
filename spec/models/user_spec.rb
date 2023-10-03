require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)

      expect(user).to be_valid
    end

    describe 'email_validations' do
      it 'is invalid without an email' do
        user = build(:user, email: nil)

        expect(user).to be_invalid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'is invalid with a duplicate email' do
        create(:user, email: 'test@example.com')
        user = build(:user, email: 'test@example.com')

        expect(user).to be_invalid
        expect(user.errors[:email]).to include('has already been taken')
      end
    end

    describe 'status validation' do
      it 'is invalid without a status' do
        user = build(:user, status: nil)

        expect(user).to be_invalid
        expect(user.errors[:status]).to include("can't be blank")
      end

      # it 'is invalid with an invalid status' do
      #   user = User.new
      #   user.status = 'invalid_status'

      #   expect(user).to be_invalid
      #   expect(user.errors[:status]).to include('is not included in the list')
      # end

      it 'is valid with a valid status' do
        user = build(:user, status: 'active')

        expect(user).to be_valid
      end
    end

    it 'is invalid without an encrypted_password' do
      user = build(:user, encrypted_password: nil)

      expect(user).to be_invalid
      expect(user.errors[:encrypted_password]).to include("can't be blank")
    end

    it 'is invalid without a name' do
      user = build(:user, name: nil)

      expect(user).to be_invalid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without total_transaction_sum' do
      user = build(:user, total_transaction_sum: nil)

      expect(user).to be_invalid
      expect(user.errors[:total_transaction_sum]).to include("can't be blank")
    end

    it 'is invalid with a negative total_transaction_sum' do
      user = build(:user, total_transaction_sum: -10)

      expect(user).to be_invalid
      expect(user.errors[:total_transaction_sum]).to include('must be greater than or equal to 0')
    end

    it 'is valid with a valid total_transaction_sum' do
      user = build(:user, total_transaction_sum: 100)

      expect(user).to be_valid
    end
  end
end
