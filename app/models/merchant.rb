# == Schema Information
#
# Table name: users
#
#  id                    :bigint           not null, primary key
#  email                 :string           default(""), not null
#  encrypted_password    :string           default(""), not null
#  remember_created_at   :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  status                :enum             default("active"), not null
#  name                  :string           not null
#  description           :text
#  total_transaction_sum :decimal(, )      default(0.0), not null
#  user_type             :string           default("Merchant"), not null
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
