# spec/factories/transactions.rb
FactoryBot.define do
  factory :transaction do
    uuid { SecureRandom.uuid }
    status { 'approved' }
    customer_email { 'customer@example.com' }

    transient do
      txn_amount { 100.00 }
    end

    association :merchant, factory: :merchant

    after(:build) do |transaction, eval|
      transaction.txn_amount = eval.txn_amount
      transaction.payment = build(:payment, amount: eval.txn_amount, monetizable: transaction) if transaction.respond_to?(:payment)
    end
  
    # after(:create) do |transaction|
    #   transaction.payment.save!
    # end
  end

  factory :authorize_transaction, parent: :transaction, class: 'AuthorizeTransaction' do
    # Additional attributes specific to AuthorizeTransaction if any
    transaction_type { 'AuthorizeTransaction' }
    association :merchant, factory: :merchant

    trait :with_reference_transaction do
      association :reference_transaction, factory: :authorize_transaction
    end
  end

  factory :charge_transaction, parent: :transaction, class: 'ChargeTransaction' do
    # Additional attributes specific to ChargeTransaction if any
    transaction_type { 'ChargeTransaction' }

    association :merchant, factory: :merchant
    association :reference_transaction, factory: :authorize_transaction

    trait :with_reference_transaction do
      association :reference_transaction, factory: :authorize_transaction
    end
  end

  factory :refund_transaction, parent: :transaction, class: 'RefundTransaction' do
    # Additional attributes specific to RefundTransaction if any
    association :merchant, factory: :merchant
    association :reference_transaction, factory: :charge_transaction

    trait :with_reference_transaction do
      association :reference_transaction, factory: :charge_transaction
    end
  end

  factory :reversal_transaction, parent: :transaction, class: 'ReversalTransaction' do
    # Additional attributes specific to ReversalTransaction if any
    association :merchant, factory: :merchant
    association :reference_transaction, factory: :authorize_transaction

    trait :with_reference_transaction do
      association :reference_transaction, factory: :authorize_transaction
    end
  end
end
