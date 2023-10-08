class Merchant < User

  has_many :transactions

  def total_charges_collected
    approved_charge_transaction = transactions.approved.where(transaction_type: 'ChargeTransaction')
    charges_collected = Payment.where(
      monetizable_type: 'Transaction',
      monetizable_id: approved_charge_transaction.ids
    ).pluck(:amount).sum
  end

  def recalculate_total_charges_collected
    update!(total_transaction_sum: total_charges_collected)
  end
end
