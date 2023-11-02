# == Schema Information
#
# Table name: users
#
# @!attribute id
#   @return []
# @!attribute email
#   @return [String]
# @!attribute encrypted_password
#   @return [String]
# @!attribute remember_created_at
#   @return [Time]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
# @!attribute status
#   @return []
# @!attribute name
#   @return [String]
# @!attribute description
#   @return [String]
# @!attribute total_transaction_sum
#   @return []
# @!attribute user_type
#   @return [String]
#
class Merchant < User
  has_many :transactions
  has_one :api_token, dependent: :destroy

  validates :total_transaction_sum, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_create :setup_api_token

  def total_charges_collected
    approved_authorize_transactions = transactions.approved.where(transaction_type: 'AuthorizeTransaction')
    approved_charge_transactions = transactions.approved.where(transaction_type: 'ChargeTransaction', reference_transaction_id: approved_authorize_transactions.ids)
    charges_collected = Payment.where(
      monetizable_type: 'Transaction',
      monetizable_id: approved_charge_transactions.ids
    ).pluck(:amount).sum
  end

  def recalculate_total_charges_collected
    update!(total_transaction_sum: total_charges_collected)
  end

  private

  def setup_api_token
    ApiToken.create!(merchant: self)
  end
end
