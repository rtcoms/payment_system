class TransactionSerializer < ActiveModel::Serializer
  attributes :uuid, :status, :customer_email, :customer_phone, :merchant_id, :reference_transaction_id,
             :transaction_type, :created_at, :updated_at, :amount

  def amount
    self.object.try(:payment).try(:amount).to_f
  end
end